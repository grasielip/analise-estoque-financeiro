-- Projeto: Análise de Estoque e Desempenho Financeiro
-- Banco: MySQL 8+
CREATE DATABASE IF NOT EXISTS analise_estoque;
USE analise_estoque;

DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS movimentacoes_estoque;
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS fornecedores;

CREATE TABLE fornecedores (
    fornecedor_id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(80)
);

CREATE TABLE produtos (
    produto_id INT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(60) NOT NULL,
    custo_unitario DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    estoque_minimo INT NOT NULL DEFAULT 5
);

CREATE TABLE compras (
    compra_id INT PRIMARY KEY,
    data_compra DATE NOT NULL,
    fornecedor_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    custo_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_compras_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(fornecedor_id),
    CONSTRAINT fk_compras_produto FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

CREATE TABLE movimentacoes_estoque (
    movimentacao_id INT PRIMARY KEY,
    data_movimentacao DATE NOT NULL,
    produto_id INT NOT NULL,
    tipo ENUM('ENTRADA','SAIDA') NOT NULL,
    quantidade INT NOT NULL,
    origem VARCHAR(30) NOT NULL,
    CONSTRAINT fk_mov_produto FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

CREATE TABLE vendas (
    venda_id INT PRIMARY KEY,
    data_venda DATE NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_vendas_produto FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);
