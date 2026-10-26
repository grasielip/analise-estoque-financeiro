# Análise de Estoque e Desempenho Financeiro

## Contexto
Projeto de portfólio de análise de dados para uma empresa fictícia de comércio. Os dados foram gerados artificialmente para praticar modelagem relacional, SQL e construção de indicadores.

## Objetivo
Investigar a composição do estoque, identificar produtos abaixo do mínimo e analisar receita, compras e margem bruta estimada para apoiar decisões de reposição e gestão financeira.

## Perguntas de negócio
- Quais produtos concentram o valor do estoque (Curva ABC)?
- Quais produtos estão abaixo do estoque mínimo?
- Quais produtos geram mais receita e margem bruta estimada?
- Como a receita e o valor das compras variam por mês?
- Quais produtos merecem investigação por baixo giro?

## Ferramentas
- MySQL 8+
- Excel (tabelas dinâmicas e validação exploratória)
- Power BI (dashboard)
- Git e GitHub

## Estrutura
- `dados/`: arquivos CSV fictícios, separados por ponto e vírgula.
- `sql/01_criar_tabelas.sql`: banco e tabelas com chaves primárias e estrangeiras.
- `sql/02_consultas_analiticas.sql`: consultas para receita, margem estimada, Curva ABC, estoque mínimo, compras mensais e ranking.

## Como executar
1. Instale o MySQL 8 ou superior.
2. Execute `sql/01_criar_tabelas.sql`.
3. Importe os CSVs da pasta `dados/` para as tabelas correspondentes, respeitando a ordem:
   `fornecedores`, `produtos`, `compras`, `movimentacoes_estoque`, `vendas`.
4. Execute `sql/02_consultas_analiticas.sql`.

Os CSVs usam `;` como delimitador e codificação UTF-8 com BOM para facilitar a abertura no Excel.

## Indicadores sugeridos para o Power BI
- Receita total
- Custo estimado das mercadorias vendidas
- Margem bruta estimada
- Valor atual do estoque
- Quantidade de produtos abaixo do mínimo
- Receita mensal
- Valor de compras mensal
- Distribuição ABC por valor de estoque

## Cuidados metodológicos
- Todos os dados são fictícios e não representam uma empresa real.
- A margem é estimada usando o custo unitário atual do cadastro de produtos, não o custo histórico de cada lote vendido. Isso deve ser explicado no portfólio.
- A comparação entre compras e vendas não equivale diretamente a fluxo de caixa: datas de pagamento e recebimento não estão modeladas.
- Para medir giro e identificar itens parados com precisão, será necessário definir uma janela de análise e considerar o estoque inicial/final e as datas das movimentações.
- A classificação ABC depende da regra adotada. Neste projeto, os limites de referência são aproximadamente 80% para A e 95% para B.

## Próximas melhorias
- Criar uma tabela calendário.
- Acrescentar custo histórico por compra/lote.
- Criar análise de giro e dias sem venda.
- Construir dashboard Power BI com páginas Estoque e Financeiro.
- Incluir prints do dashboard e conclusões baseadas nos resultados obtidos.
