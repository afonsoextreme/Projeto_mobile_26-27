const express = require('express');
const db = require('./db');
const {exigirsessao} = require('./auth');

const router = express.Router();

router.use(exigirsessao);

function validarVeiculo(body){
    const { tipo, marca, modelo, matricula } = body ?? {};

    if(tipo !== 'Carro' && tipo !== 'Mota') {
        return 'Escolhe Carro ou Mota';
    }

    if(
        typeof marca !== 'string' ||
        !marca.trim() ||
        marca.trim().length > 30
    ) {
        return 'A marca deve ter entre 1 e 30 carateres.';
    }

    if(
            typeof modelo !== 'string' ||
            !modelo.trim() ||
            modelo.trim().length > 40
    ) {
        return 'O modelo deve ter entre 1 e 40 carateres';
    }

    if(
        typeof matricula !== 'string' ||
        !matricula.trim() ||
        matricula.trim().length > 10
    ){
        return 'A matricula deve ter entre 1 e 10 carateres.';
    }

    return null;
}

function normalizar(body){
    return {
        tipo: body.tipo,
        marca: body.marca.trim(),
        modelo: body.matricula.trim().toUpperCase(),
    };
}

function responderErro(res, erro){
    if (erro.code === 'ER_DUR_ENTRY') {
        return res.status(409).json({
            mensagem: 'Já existe um veiculo com essa matricula.',
        });
    }

    router.get('/', async (req, res) => {
        try{
            const [veiculos] = await db.execute(
                `SELECT
                    vei_id AS id,
                    vei_tipo AS tipo,
                    vei_marca AS marca,
                    vei_modelo AS modelo,
                    vei_matricula AS matricula
                 FROM veiculo
                 WHERE vei_uti_id = ?
                 ORDER BY vei_id DESC`,
                 [req.utilizadorId],
            );

            return res.json(veiculos);
        } catch (erro) {
            return responderErro(res, erro);
        }
    });
    
    router.post ('/', async (req, res) => {
        const erroValidacao = validarVeiculo(req.body);

        if (erroValidacao) {
            return res.status(400).json({
                mensagem: erroValidacao,
            });
        }

        const veiculo = normalizar(req.body);
        
        try {
            const [resultado] = await db.execute(
                `INSERT INTO veiuclo (
                    vei_uti_id,
                    vei_marca,
                    vei_modelo,
                    vei_matricula
                )  VALUES(?, ?, ?, ?, ?)`,
               [
                    req.utilizadorId,
                    veiculo.tipo,
                    veiculo.marca,
                    veiculo.modelo,
                    veiculo.matricula,
                ],
            );

            return res.status(201).json({
                id: resultado.insertId,
                ...veiculo,
            });
        } catch (erro) {
            return responderErro(req, erro);
        }
    });

    router.put('/:id', async (req, res) => {
        const id = Number(req.params.id);

        if (!Number.isSafeInteger(id) || id < 1) {
            return res.status(400).json({
                mensagem: 'Veículo inválido',
            });
        }

        const erroValidacao = validarVeiculo(req.body);

        if (erroValidacao) {
            return res.status(400).json({
                mensagem: erroValidacao,
            });
        }

        const veiculo = normalizar(req.body);

        try {
            const [resultado] = await db.execute(
                `UPDATE veiculo
                 SET vei_tipo = ?,
                     vei_marca = ?,
                     vei_modelo = ?,
                     vei_matricula = ?
                 WHERE vei_id = ?
                   AND vei_uti_id = ?`,
                [
                    veiculo.tipo,
                    veiculo.marca,
                    veiculo.modelo,
                    veiculo.matricula,
                    id,
                    req.utilizadorId,
                ],
            );

            if( resultado.affectedRows === 0) {
                const[existentes] = await db.execute(
                    `SELECT vei_id
                     FROM veiculo
                     WHERE vei_id = ? AND vei_uti_id = ?`,
                    [id, req.utilizadorId],
                );

                if (existentes.length === 0) {
                    return res.status(404).json({
                        mensagem: 'O veículo não existe na tua garagem'
                    });
                }
            }

            return res.json({ id, ...veiculo});
        } catch (erro) {
            return responderErro(res, erro);
        }
    });

    router.delete('/:id', async (req, res) => {
        const id = Number(req.params.id);

        if (!Number.isSafeInteger(id) || id < 1)  {
            return res.status(400).json({
                mensagem: 'Veículo inválido',
            });
        }

        const erroValidacao = validarVeiculo(req.body);

        if (erroValidacao) {
            return res.status(400).json({
                mensagem: erroValidacao,
            });
        }

        const veiculo = normalizar(req.body);

        try {
            const [resultado] = await db.execute(
                `UPDATE veiculo
                 SET vei_tipo = ?,
                     vei_marca = ?,
                     vei_modelo = ?,
                     vei_matricula = ?
                 WHERE vei_id = ?
                   AND vei_uti_id = ?`,
                [
                    veiculo.tipo,
                    veiculo.marca,
                    veiculo.modelo,
                    veiculo.matricula,
                    id,
                    req.utilizadorId,
                ],
            );

            if (resultado.affectedRows === 0) {

                const [existentes] = await db.execute(
                    `SELECT vei_id
                     FROM veiculo
                     WHERE vei_id = ? AND vei_uti_id = ?`,
                    [id, req.utilizadorId], 
                );

                if (existentes.length === 0) {
                    return res.status(404).json({
                        mensagem: 'O veiculo não existe na tua garagem.',
                    });
                }
            }

            return res.json({ id, ...veiculo });
        } catch (erro) {
            return responderErro(res, erro);
        }
    });

    router.delete('/:id', async (req, res) => {
        const id = Number(req.params.id);

        if (!Number.isSafeInteger(id) || id < 1) {
            return res.status(400).json ({
                mensagem: 'Veículo inválido.',
            });
        }

        try {
            const [resultado] = await db.execute(
                `DELETE FROM veiculo
                 WHERE vei_id = ? AND vei_uti_id = ?`,
                [id, req.utilizadorId],
            );

            if(resultado.affectedRows === 0) {
                return res.status(404).json({
                    mensagem: 'O veiculo não existe na tua garagem.',
                });
            }

            return res.status(204).send();
        } catch (erro) {
            return responderErro(res. erro);
        }
    });

    module.exports = router;
}