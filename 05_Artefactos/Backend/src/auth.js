const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('./db');

const router = express.Router();
const segredo = process.env.JWT_SECRET;

if (!segredo || segredo.length < 32){
    throw new Error('Configura JWT_SECRET no ficheiro .env.');
}

function criarSessao(utilizador){
    const token = jwt.sign({}, segredo, {
        subject: String(utilizador.id),
        algorithm: 'HS256',
        expiresIn: '8h',
    });

    return{
        token,
        utilizador: {
            id: utilizador.id,
            nome: utilizador.nome,
            email: utilizador.email,
        },
    };
}

function emailValido(email) {
    return typeof email === 'string' &&
        email.trim().length <= 60 &&
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());
}

router.post('/registo', async (req, res) =>{
    const{ nome, email, password } = req.body ?? {};

    if(
        typeof nome !== 'string' ||
        !nome.trim() ||
        nome.trim().length > 60
    ) {
        return res.status(400).json({
            mensagem: 'Introduz um nome com 1 a 60 carateres.',
        });
    }

    if(!emailValido(email)) {
        return res.status(400).json({
            mensagem: 'Introduz um email válido com até 60 caracteres.',
        });
    }

    if (typeof password !== 'string' || password.length < 8) {
        return res.status(400).json({
            mensagem: 'A palavra-passe deve ter pelo menos 8 carateres'
        });
    }
    if (Buffer.byteLength(password, 'utf8') > 72) {
        return res.status(400).json({
            mensagem: 'A palavra-passe é demasiado longa. Usa uma mais curta.',
        });
    }

    try {
        const emailNormalizado = email.trim().toLowerCase();
        const hash = await bcrypt.hash(password, 12);

        const [resultado] = await db.execute(
            `INSERT INTO utilizador(
                uti_nome,
                uti_email,
                uti_password
            ) VALUES (?, ?, ?)`,
             [nome.trim(), emailNormalizado, hash],
        );

        return res.status(201).json(criarSessao({
            id: resultado.insertId,
            nome: nome.trim(),
            email: emailNormalizado,
        }));
    } catch (erro) {
        if(erro.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({
                mensagem: 'Já existe uma conta com esse email.',
            });
        }

        console.error('Erro no registo', erro.message);

        return res.status(500).json({
            mensagem: 'Não foi possivel criar a conta.',
        });
    }
});

router.post('/login', async (req, res) => {
    const{email, password} = req.body ?? {};

    if(
        !emailValido(email) ||
        typeof password !== 'string' ||
        password.length === 0 ||
        Buffer.byteLength(password, 'utf8') > 72
    ) {
        return res.status(400).json({
            mensagem: 'Introduz um email e uma palavra-passe válidos.',
        });
    }

    try {
        const[utilizadores] = await db.execute(
            `SELECT
                uti_id AS id,
                uti_nome AS nome,
                uti_email AS email,
                uti_password AS passwordHash
            FROM utilizador
            WHERE uti_email = ?
            LIMIT 1`,
            [email.trim().toLowerCase()],
        );

        const utilizador = utilizadores[0];

        if(
            !utilizador ||
            !(await bcrypt.compare(password, utilizador.passwordHash))
        ){
            return res.status(401).json({
                mensagem: 'Email ou palavra-passe incorretos.',
            });
        }

        return res.json(criarSessao(utilizador));
    } catch(erro) {
        console.error('Erro no login', erro.message);
        
        return res.status(500).json({
            mensagem: 'Não foi possivel iniciar sessão.',
        });
    }
});

function exigirSessao(req, res, next) {
    const autorizacao = req.headers.authorization ?? '';

    if(!autorizacao.startsWith('Bearer ')) {
         return res.status(401).json({
            mensagem: 'Inicia sessão para continuar.',
        });
    }

    try {
        const dados = jwt.verify(
            autorizacao.slice(7),
            segredo,
            { algorithms: ['HS256'] },
        );

        const id = Number(dados.sub);

        if(!Number.isSafeInteger(id) || id < 1) {
            throw new Error('Identificador invalido.');
        }

        req.utilizadorId = id;
    } catch {
        return res.status(401).json({
            mensagem: 'A sessão expirou ou é invalida. Entra novamente.',
        });
    }

    return next();
}

module.exports = {authRouter: router, exigirSessao};