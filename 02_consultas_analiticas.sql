USE analise_estoque;

-- 1. Receita, custo estimado e margem bruta por produto
SELECT p.produto_id, p.nome, p.categoria,
       SUM(v.quantidade * v.valor_unitario) AS receita,
       SUM(v.quantidade * p.custo_unitario) AS custo_estimado,
       SUM(v.quantidade * (v.valor_unitario - p.custo_unitario)) AS margem_bruta_estimada
FROM vendas v
JOIN produtos p ON p.produto_id = v.produto_id
GROUP BY p.produto_id, p.nome, p.categoria
ORDER BY receita DESC;

-- 2. Curva ABC por valor estimado do estoque atual
-- Atenção: estoque atual é calculado pelas movimentações de entrada e saída.
WITH estoque AS (
    SELECT p.produto_id, p.nome, p.categoria, p.custo_unitario,
           COALESCE(SUM(CASE WHEN m.tipo='ENTRADA' THEN m.quantidade
                             WHEN m.tipo='SAIDA' THEN -m.quantidade END),0) AS estoque_atual
    FROM produtos p
    LEFT JOIN movimentacoes_estoque m ON m.produto_id=p.produto_id
    GROUP BY p.produto_id, p.nome, p.categoria, p.custo_unitario
),
valores AS (
    SELECT *, estoque_atual * custo_unitario AS valor_estoque
    FROM estoque
),
acumulado AS (
    SELECT *,
           SUM(valor_estoque) OVER (ORDER BY valor_estoque DESC) AS valor_acumulado,
           SUM(valor_estoque) OVER () AS valor_total
    FROM valores
)
SELECT produto_id, nome, categoria, estoque_atual, valor_estoque,
       ROUND(100 * valor_acumulado / NULLIF(valor_total,0),2) AS percentual_acumulado,
       CASE
         WHEN 100 * valor_acumulado / NULLIF(valor_total,0) <= 80 THEN 'A'
         WHEN 100 * (valor_acumulado - valor_estoque) / NULLIF(valor_total,0) < 95 THEN 'B'
         ELSE 'C'
       END AS classe_abc
FROM acumulado
ORDER BY valor_estoque DESC;

-- 3. Itens abaixo do estoque mínimo
WITH estoque AS (
    SELECT p.produto_id, p.nome, p.estoque_minimo,
           COALESCE(SUM(CASE WHEN m.tipo='ENTRADA' THEN m.quantidade
                             WHEN m.tipo='SAIDA' THEN -m.quantidade END),0) AS estoque_atual
    FROM produtos p
    LEFT JOIN movimentacoes_estoque m ON m.produto_id=p.produto_id
    GROUP BY p.produto_id, p.nome, p.estoque_minimo
)
SELECT *, estoque_minimo - estoque_atual AS quantidade_para_repor
FROM estoque
WHERE estoque_atual < estoque_minimo
ORDER BY quantidade_para_repor DESC;

-- 4. Receita mensal
SELECT DATE_FORMAT(data_venda,'%Y-%m') AS mes,
       SUM(quantidade * valor_unitario) AS receita
FROM vendas
GROUP BY DATE_FORMAT(data_venda,'%Y-%m')
ORDER BY mes;

-- 5. Produtos com maior receita e margem percentual estimada
SELECT p.nome,
       SUM(v.quantidade * v.valor_unitario) AS receita,
       SUM(v.quantidade * (v.valor_unitario-p.custo_unitario)) AS margem_bruta_estimada,
       ROUND(100 * SUM(v.quantidade * (v.valor_unitario-p.custo_unitario)) /
             NULLIF(SUM(v.quantidade * v.valor_unitario),0),2) AS margem_percentual_estimada
FROM vendas v
JOIN produtos p ON p.produto_id=v.produto_id
GROUP BY p.produto_id,p.nome
ORDER BY receita DESC;

-- 6. Compras por mês: valor de aquisição estimado
SELECT DATE_FORMAT(data_compra,'%Y-%m') AS mes,
       SUM(quantidade * custo_unitario) AS valor_compras
FROM compras
GROUP BY DATE_FORMAT(data_compra,'%Y-%m')
ORDER BY mes;

-- 7. Ranking de produtos por receita
WITH receita_produto AS (
    SELECT p.produto_id,p.nome,SUM(v.quantidade*v.valor_unitario) AS receita
    FROM produtos p JOIN vendas v ON v.produto_id=p.produto_id
    GROUP BY p.produto_id,p.nome
)
SELECT *, RANK() OVER (ORDER BY receita DESC) AS ranking_receita
FROM receita_produto;
