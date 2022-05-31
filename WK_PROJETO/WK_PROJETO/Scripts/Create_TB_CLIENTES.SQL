CREATE TABLE `tb_clientes` (
  `CODIGO` int NOT NULL,
  `NOME` varchar(50) NOT NULL,
  `CIDADE` varchar(50) NOT NULL,
  `UF` char(2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
