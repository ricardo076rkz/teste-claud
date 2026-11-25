-- AFASA SYSTEMS - migration para materiais de estudo
-- Execute uma vez no banco PostgreSQL utilizado pela aplicação.
-- Não apaga nem recria tabelas ou registros existentes.

CREATE TABLE IF NOT EXISTS material (
    id_material INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    tipo VARCHAR(10) NOT NULL
        CHECK (tipo IN ('video', 'pdf', 'link')),
    url VARCHAR(500) NOT NULL,
    id_curso INT NOT NULL,
    id_aula INT NULL,
    CONSTRAINT fk_material_curso
        FOREIGN KEY (id_curso)
        REFERENCES curso(id_curso)
        ON DELETE CASCADE,
    CONSTRAINT fk_material_aula
        FOREIGN KEY (id_aula)
        REFERENCES aula(id_aula)
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_material_curso
    ON material (id_curso);

CREATE INDEX IF NOT EXISTS idx_material_aula
    ON material (id_aula);
