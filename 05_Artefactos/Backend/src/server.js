const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
const PORT = 3000;
const {authRouter, exigirSessao} = require('./auth');
const veiculosRouter = require('./veiculos');


app.use(cors());
app.use(express.json());
app.use('/api/auth', authRouter);
app.use('/api/veiculos', veiculosRouter);

app.get('/api/health',(req, res) => {
    res.json({
        status: 'ok',
        mensagem: 'API RideSync a funcionar!',
    });
});


app.get('/api/passeios', async (req, res) =>{
    try{
        const [passeiosBD] = await db.execute(`
            SELECT
                p.pas_id AS id,
                p.pas_uti_id AS organizadorId,
                p.pas_nome AS nome,
                COALESCE(p.pas_descricao, '') AS descricao,
                p.pas_partida AS partida,
                p.pas_destino AS destino,
                p.pas_data_hora AS data,
                p.pas_limite_participantes AS limiteParticipantes,
                p.pas_estado AS estado,
                (
                    SELECT COUNT(*)
                    FROM inscricao i
                    WHERE i.ins_pas_id = p.pas_id
                      AND i.ins_estado = 'confirmada'
                ) AS participantes
            FROM passeio p
            ORDER BY p.pas_data_hora ASC
        `);
        
        res.json(passeiosBD);
    } catch (erro) {
        console.error('Errp ao listar passeios:', erro.message);

        res.status(500).json({
            mensagem: 'Não foi possivel carregar os passeios.',
        });
    }
});

app.patch('/api/passeios/:id/estado', exigirSessao, async (req, res) => {
    const id = Number(req.params.id);
    const {estado} = req.body ?? {}

    if(!Number.isSafeInteger(id) || id < 1) {
        return res.status(400).json({
            mensagem: 'Passeio inválido.',
        });
    }

    if(estado !== 'emCurso' && estado !== 'terminado') {
        return res.status(400).json({
            mensagem: 'Estado inválido',
        });
    }

    try{
        const estadoAnterior =
            estado === 'emCurso' ? 'agendado' : 'emCurso';

        const sql = estado === 'emCurso'
            ? `UPDATE passeio
                SET pas_estado = ?, pas_data_inicio = CURRENT_TIMESTAMP
                WHERE pas_id = ?
                  AND pas_uti_id = ?
                  AND pas_estado = ?`
            : `UPDATE passeio
               SET pas_estado = ?, pas_data_fim = CURRENT_TIMESTAMP
               WHERE pas_id = ?
                 AND pas_uti_id = ?
                 AND pas_estado = ?`;

        const [resultado] = await db.execute(sql, [
            estado,
            id,
            req.utilizadorId,
            estadoAnterior,
        ]);

        if (resultado.affectedRows === 1) {
            return res.json({id, estado});
        }

        const [passeios] = await db.execute(
            `SELECT
                pas_uti_id AS organizadorId,
                pas_estado AS estado
            FROM passeio
            WHERE pas_id = ?`,
            [id],
        );

        if (passeios.length === 0) {
            return res.status(404).json({
                mensagem: 'O passeio já não existe.',
            });
        }

        const passeio =passeios[0];

        if (passeio.organizadorId !== req.utilizadorId) {
            return res.status(403).json({
                mensagem: 'Só o organizador pode alterar o estado.',
            });
        }

        if (passeio.estado === estado) {
            return res.json({id, estado});
        }

        return res.status(409).json({
            mensagem:
                'O passeio já não pode permite esta alteração. Atualiza a lista.',
        });
    } catch (erro) {
        console.error('Erro ao alterar estado:', erro.message);

        return res.status(500).json({
            mensagem: 'Não foi possivel atualizar o passeio.',
        });
    }
});

app.listen(PORT, '0.0.0.0',() =>{
    console.log(`Api RideSync disponivel em http://localhost:${PORT}`);
});


app.post('/api/passeios', exigirSessao,async (req, res) => {
    const {
        nome,
        descricao = '',
        partida,
        destino,
        data, 
        limiteParticipantes,
    } = req.body ?? {};
    
    const camposObrigatorios = [nome, partida, destino];

    if(camposObrigatorios.some(
        valor => typeof valor !== 'string' || !valor.trim()
    )) {
        return res.status(400).json({
            mensagem: 'Preenche o nome, a partida e o destino.',
        });
    }

    if (
        nome.trim().length > 60 ||
        partida.trim().length > 80 ||
        destino.trim().length > 80
    ) {
        return res.status(400).json({
            mensagem:
                'O nome pode ter até 60 carateres e os locais até 80.',
        });
    }

    if(typeof descricao !== 'string' || descricao.length > 500) {
        return res.status(400).json({
            mensagem: 'A descrição deve ter até 500 carateres.',
        });
    }
    
    const dataHora = typeof data === 'string'
        ? new Date(data)
        : new Date(NaN);
    if(
        Number.isNaN(dataHora.getTime()) ||
        dataHora.getTime() <= Date.now()
    ) {
        return res.status(400).json({
            mensagem: 'Escolhe uma data e hora futuras',
        });
    }

    if (
        !Number.isInteger(limiteParticipantes) ||
        limiteParticipantes < 1
    ) {
        return res.status(400).json({
            mensagem: 'O limite de participantes deve ser pelo menos 1.',
        });
    }

    const organizadorId = req.utilizadorId;
    
    let ligacao;
    
    try {
        ligacao = await db.getConnection();
        await ligacao.beginTransaction();

        const [utilizadores] = await ligacao.execute(
            'SELECT uti_id FROM utilizador WHERE uti_id = ?',
            [organizadorId],
        );

        if (utilizadores.length === 0) {
            await ligacao.rollback();

            return res.status(500).json({
                mensagem: 'O utilizador não existe na BD.',
            });
        }

        const [resultado] = await ligacao.execute(
            `INSERT INTO passeio (
                pas_uti_id,
                pas_nome,
                pas_descricao,
                pas_partida,
                pas_destino,
                pas_data_hora,
                pas_limite_participantes,
                pas_estado
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                organizadorId,
                nome.trim(),
                descricao.trim(),
                partida.trim(),
                destino.trim(),
                dataHora,
                limiteParticipantes,
                'agendado',
            ],
        );
        
        const passeioId = resultado.insertId;

        await ligacao.execute(
            `INSERT INTO inscricao(
                ins_uti_id,
                ins_pas_id,
                ins_vei_id,
                ins_estado
            ) VALUES (?, ?, NULL, ?)`,
            [organizadorId, passeioId, 'confirmada'],
        );

        await ligacao.commit();

        return res.status(201).json({
            id: passeioId,
            nome: nome.trim(),
            descricao: descricao.trim(),
            partida: partida.trim(),
            destino: destino.trim(),
            data: dataHora.toISOString(),
            limiteParticipantes,
            participantes: 1,
            estado: 'agendado',
        });
    } catch (erro) {
        if (ligacao) {
            try {
                await ligacao.rollback();
            } catch (erroRollback) {
                console.error(
                    'Erro ao reverter a transação:',
                    erroRollback.message,
                );
            }
        }

        console.error('Erro ao criar passeio:', erro.message);

        return res.status(500).json({
            mensagem: 'Não foi possivel guardar o passeio.',
        });
    } finally {
        if (ligacao) {
            ligacao.release();
        }
    }
});


