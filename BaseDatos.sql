-- =====================================================
-- Script de Base de Datos - Sistema de Microservicios
-- =====================================================
-- Este script contiene el esquema completo de la base de datos
-- para el sistema de gestión de clientes y cuentas bancarias
-- =====================================================

-- =====================================================
-- ESQUEMA: Customer Service Database
-- =====================================================

-- Tabla: persons
-- Descripción: Almacena información de personas
-- public.persons definition

CREATE TABLE public.persons (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	gender varchar(50) NOT NULL,
	identification varchar(100) NOT NULL,
	address varchar(500) NULL,
	phone varchar(50) NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT persons_identification_key UNIQUE (identification),
	CONSTRAINT persons_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_persons_identification ON public.persons USING btree (identification);

-- Tabla: customers
-- Descripción: Almacena información de clientes que heredan de Person
-- Customer hereda todos los campos de Person (name, gender, identification, address, phone)
-- public.customers definition

CREATE TABLE public.customers (
	id bigserial NOT NULL,
	person_id int8 NOT NULL,
	"password" varchar(255) NOT NULL,
	status bool DEFAULT true NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT customers_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_customers_person_id ON public.customers USING btree (person_id);


-- public.customers foreign keys

ALTER TABLE public.customers ADD CONSTRAINT customers_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;

-- =====================================================
-- ESQUEMA: Account Service Database
-- =====================================================

-- Tabla: accounts
-- Descripción: Almacena información de cuentas bancarias
-- public.accounts definition


CREATE TABLE public.accounts (
	id bigserial NOT NULL,
	account_number varchar(50) NOT NULL,
	account_type varchar(50) NOT NULL,
	initial_balance numeric(19, 2) NOT NULL,
	current_balance numeric(19, 2) NOT NULL,
	status bool DEFAULT true NOT NULL,
	customer_id int8 NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT accounts_account_number_key UNIQUE (account_number),
	CONSTRAINT accounts_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_accounts_account_number ON public.accounts USING btree (account_number);
CREATE INDEX idx_accounts_customer_id ON public.accounts USING btree (customer_id);

-- Tabla: movements
-- Descripción: Almacena los movimientos (transacciones) de las cuentas
-- public.movements definition


CREATE TABLE public.movements (
	id bigserial NOT NULL,
	account_id int8 NOT NULL,
	movement_date timestamp NOT NULL,
	movement_type varchar(20) NOT NULL,
	value numeric(19, 2) NOT NULL,
	balance numeric(19, 2) NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT movements_movement_type_check CHECK (((movement_type)::text = ANY ((ARRAY['DEBIT'::character varying, 'CREDIT'::character varying])::text[]))),
	CONSTRAINT movements_pkey PRIMARY KEY (id),
	CONSTRAINT movements_value_check CHECK ((value > (0)::numeric))
);
CREATE INDEX idx_movements_account_id ON public.movements USING btree (account_id);
CREATE INDEX idx_movements_date ON public.movements USING btree (movement_date);


-- public.movements foreign keys

ALTER TABLE public.movements ADD CONSTRAINT movements_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;

-- =====================================================
-- ÍNDICES
-- =====================================================

-- Índices para Customer Service
CREATE INDEX idx_customers_person_id ON public.customers USING btree (person_id);
CREATE INDEX idx_persons_identification ON public.persons USING btree (identification);
CREATE UNIQUE INDEX persons_identification_key ON public.persons USING btree (identification);
CREATE UNIQUE INDEX customers_pkey ON public.customers USING btree (id);
CREATE UNIQUE INDEX persons_pkey ON public.persons USING btree (id);

-- Índices para Account Service
CREATE INDEX IF NOT EXISTS idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX IF NOT EXISTS idx_accounts_account_number ON accounts(account_number);
CREATE INDEX IF NOT EXISTS idx_movements_account_id ON movements(account_id);
CREATE INDEX IF NOT EXISTS idx_movements_date ON movements(movement_date);

-- Datos de la tabla accounts
id|account_number|account_type|initial_balance|current_balance|status|customer_id|created_at             |updated_at             |
--+--------------+------------+---------------+---------------+------+-----------+-----------------------+-----------------------+
 1|1234567890    |SAVINGS     |        1000.00|        1300.00|true  |          3|2025-11-23 17:53:30.965|2025-11-23 17:54:53.756|
 2|478758        |Ahorro      |        2000.00|        2025.00|true  |         10|2025-11-25 00:51:38.332|2025-11-25 21:09:10.340|

-- Datos de la tabla movements
id|account_id|movement_date          |movement_type|value |balance|created_at             |
--+----------+-----------------------+-------------+------+-------+-----------------------+
 1|         1|2025-11-23 17:54:03.742|CREDIT       |500.00|1500.00|2025-11-23 17:54:03.742|
 2|         1|2025-11-23 17:54:53.756|DEBIT        |200.00|1300.00|2025-11-23 17:54:53.756|
 3|         2|2025-11-25 21:07:11.303|CREDIT       |600.00|2600.00|2025-11-25 21:07:11.303|
 4|         2|2025-11-25 21:09:10.340|DEBIT        |575.00|2025.00|2025-11-25 21:09:10.340|

 -- Datos de la tabla customers
 id|person_id|password|status|created_at             |updated_at             |
--+---------+--------+------+-----------------------+-----------------------+
10|       10|1234    |true  |2025-11-25 00:37:25.728|2025-11-25 00:37:25.728|
 9|        9|1234    |true  |2025-11-25 00:36:27.893|2025-11-25 00:43:52.676|

-- Datos de la tabla persons
id|name             |gender|identification|address                    |phone     |created_at             |updated_at             |
--+-----------------+------+--------------+---------------------------+----------+-----------------------+-----------------------+
 3|Juan Pérez       |MALE  |1234567890    |Calle Principal 123, Ciudad|555-1234  |2025-11-23 12:50:07.581|2025-11-23 12:50:07.581|
 4|Alexis Altamirano|Female|1725276487    |La Santiago                |222222222 |2025-11-23 12:51:57.758|2025-11-23 12:51:57.758|
10|Ambar Almeida    |F     |0550057699    |Barrio nuevo               |0999999999|2025-11-25 00:37:25.721|2025-11-25 00:37:25.721|
 9|Freddy Altamirano|M     |1708888787001 |                           |          |2025-11-25 00:36:27.866|2025-11-25 00:43:52.680|