--
-- PostgreSQL database dump
--

\restrict BQHFugdwNzApgg5PdwKFgbPhr6DzlDyyZTV8xKA7VBAwFYMwPhp61GFgJKCZ8gB

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-09-21 00:06:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16385)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    customer_name character varying(100),
    email character varying(100),
    city character varying(50)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16408)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16397)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer,
    order_date date
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16391)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(100),
    category character varying(50),
    price numeric(10,2)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 5025 (class 0 OID 16385)
-- Dependencies: 219
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, customer_name, email, city) FROM stdin;
1	Jean Paul Igiraneza	jeanpaul@example.com	Kigali
2	Aline Uwase	aline@example.com	Huye
3	Eric Niyonzima	eric@example.com	Musanze
4	Diane Mukamana	diane@example.com	Rubavu
5	Patrick Mugisha	patrick@example.com	Kigali
6	Claudine Uwera	claudine@example.com	Muhanga
\.


--
-- TOC entry 5028 (class 0 OID 16408)
-- Dependencies: 222
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, order_id, product_id, quantity) FROM stdin;
1	1	1	2
2	1	2	1
3	2	3	3
4	2	4	2
5	3	5	2
6	3	7	1
7	4	6	1
8	4	8	3
9	5	1	1
10	5	5	2
11	6	1	3
12	6	2	2
13	7	3	5
14	7	4	3
15	8	7	2
16	8	5	3
17	9	2	3
18	9	6	2
19	10	8	6
20	10	7	1
21	11	1	5
22	11	2	4
23	12	7	3
24	12	6	4
25	13	5	5
26	13	4	5
27	14	2	5
28	14	3	8
29	15	1	4
30	15	8	10
\.


--
-- TOC entry 5027 (class 0 OID 16397)
-- Dependencies: 221
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, customer_id, order_date) FROM stdin;
1	1	2026-01-03
2	2	2026-01-08
3	3	2026-01-14
4	4	2026-01-21
5	5	2026-01-28
6	1	2026-02-02
7	3	2026-02-09
8	2	2026-02-15
9	5	2026-02-20
10	4	2026-02-26
11	1	2026-03-04
12	2	2026-03-10
13	5	2026-03-16
14	3	2026-03-22
15	1	2026-03-29
\.


--
-- TOC entry 5026 (class 0 OID 16391)
-- Dependencies: 220
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, category, price) FROM stdin;
1	Rice 1kg	Grains and Legumes	1800.00
2	Dry Beans 1kg	Grains and Legumes	1400.00
3	Irish Potatoes 1kg	Fresh Produce	700.00
4	Cooking Bananas 1kg	Fresh Produce	900.00
5	Milk 1L	Dairy	1200.00
6	Plain Yoghurt 500ml	Dairy	1500.00
7	Rwandan Tea 250g	Beverages	2500.00
8	Bottled Water 1L	Beverages	800.00
\.


--
-- TOC entry 4868 (class 2606 OID 16390)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4874 (class 2606 OID 16413)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 4872 (class 2606 OID 16402)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4870 (class 2606 OID 16396)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4876 (class 2606 OID 16414)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4877 (class 2606 OID 16419)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 4875 (class 2606 OID 16403)
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


-- Completed on 2026-09-21 00:06:32

--
-- PostgreSQL database dump complete
--

\unrestrict BQHFugdwNzApgg5PdwKFgbPhr6DzlDyyZTV8xKA7VBAwFYMwPhp61GFgJKCZ8gB

