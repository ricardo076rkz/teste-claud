# Diagnóstico — cadastro de materiais

## Causa identificada no código versionado

O backend já possui as rotas de cadastro, consulta, edição e exclusão de materiais:
- `POST /api/cursos/:id/materiais`
- `GET /api/cursos/:id/materiais`
- `PUT /api/materiais/:id`
- `DELETE /api/materiais/:id`

O cadastro executa INSERT na tabela PostgreSQL `material`, com as colunas `titulo`, `tipo`, `url`, `id_curso` e `id_aula`.

Entretanto, o arquivo `BancoDeDados/BancoUnico.sql` do repositório oficial define as tabelas `curso` e `aula`, mas não cria a tabela `material`. Portanto, em um banco montado a partir desse script, a tentativa de cadastrar qualquer tipo de material falha no INSERT, independentemente de ser vídeo, PDF ou link.

A tela envia os campos esperados pelo backend (`titulo`, `tipo`, `url`, `id_aula`), e o backend aceita os tipos `video`, `pdf` e `link`. A validação adicional exige URL HTTP/HTTPS; PDF precisa terminar em .pdf e vídeo precisa ser YouTube/Vimeo ou arquivo .mp4/.webm/.ogg.

## Correção

Foi adicionada a migration `BancoDeDados/migration_materiais.sql`. Ela cria a tabela ausente e índices, sem apagar ou recriar tabelas existentes. A migration é idempotente quanto à criação da tabela e dos índices.

## Como aplicar

1. Abra o pgAdmin e conecte ao mesmo banco PostgreSQL configurado em `DATABASE_URL` no arquivo local `.env`.
2. Abra o Query Tool desse banco.
3. Abra e execute o conteúdo de `BancoDeDados/migration_materiais.sql`.
4. Confirme a existência da tabela com:

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name = 'material';
```

5. Confirme as colunas com:

```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'material'
ORDER BY ordinal_position;
```

6. Reinicie a aplicação (`npm start`) e tente cadastrar um material de cada tipo com URLs válidas.

## Limite da validação

A causa foi identificada comparando o SQL versionado com as consultas do backend. Não foi possível executar um teste de integração real porque não há acesso às credenciais nem ao banco PostgreSQL do ambiente. A correção só pode ser considerada confirmada depois de executar a migration no banco usado pela aplicação e testar os três tipos.
