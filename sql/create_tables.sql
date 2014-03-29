--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: hs_2json(hstore); Type: FUNCTION; Schema: public; Owner: spacialdb
--

CREATE FUNCTION hs_2json(hs hstore) RETURNS text
    LANGUAGE sql
    AS $_$

           select '{' || array_to_string(array_agg(
                  '"' || regexp_replace(key,E'[\"]',E'\&','g') || '":' ||
                  case
                    when value is null then 'null'
                    when value ~ '^(true|false|(-?(0|[1-9]d*)(.d+)?([eE][+-]?d+)?))$' then value
                    else '"' || regexp_replace(value,E'[\"]',E'\&','g') || '"'
                  end
               ),',') || '}'
           from each($1)

        $_$;


ALTER FUNCTION public.hs_2json(hs hstore) OWNER TO spacialdb;

--
-- Name: pgpool_regclass(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgpool_regclass(cstring) RETURNS oid
    LANGUAGE c STRICT
    AS '$libdir/pgpool-regclass', 'pgpool_regclass';


ALTER FUNCTION public.pgpool_regclass(cstring) OWNER TO postgres;

--
-- Name: busstops_id_seq; Type: SEQUENCE; Schema: public; Owner: kjntea_omsysv
--

CREATE SEQUENCE busstops_id_seq
    START WITH 12
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.busstops_id_seq OWNER TO kjntea_omsysv;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: BusStops; Type: TABLE; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE TABLE "BusStops" (
    id integer DEFAULT nextval('busstops_id_seq'::regclass) NOT NULL,
    name character varying(50),
    location geography,
    "references" integer,
    reference_delta interval
);


ALTER TABLE public."BusStops" OWNER TO kjntea_omsysv;

--
-- Name: COLUMN "BusStops"."references"; Type: COMMENT; Schema: public; Owner: kjntea_omsysv
--

COMMENT ON COLUMN "BusStops"."references" IS 'Used to referances another bus stop for timetable data. Used is precise data is not avaliable for this stop.

Used with referance_delta to calculate departure time.';


--
-- Name: BusStops_to_geometry; Type: VIEW; Schema: public; Owner: kjntea_omsysv
--

CREATE VIEW "BusStops_to_geometry" AS
SELECT "BusStops".id, "BusStops".name, ("BusStops".location)::geometry AS location FROM "BusStops";


ALTER TABLE public."BusStops_to_geometry" OWNER TO kjntea_omsysv;

--
-- Name: departures_id_seq; Type: SEQUENCE; Schema: public; Owner: kjntea_omsysv
--

CREATE SEQUENCE departures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departures_id_seq OWNER TO kjntea_omsysv;

--
-- Name: Departures; Type: TABLE; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE TABLE "Departures" (
    id integer DEFAULT nextval('departures_id_seq'::regclass) NOT NULL,
    timetable_id integer NOT NULL,
    valid_days character varying[] NOT NULL,
    "time" time without time zone NOT NULL,
    destination character varying(50),
    bus_stop_id integer NOT NULL
);


ALTER TABLE public."Departures" OWNER TO kjntea_omsysv;

--
-- Name: Departures_dereferenced; Type: VIEW; Schema: public; Owner: kjntea_omsysv
--

CREATE VIEW "Departures_dereferenced" AS
SELECT "Departures".id, "Departures".timetable_id, "Departures".valid_days, "Departures"."time", "Departures".destination, "Departures".bus_stop_id, false AS generated FROM "Departures" UNION ALL SELECT d.id, d.timetable_id, d.valid_days, (d."time" + COALESCE(s.reference_delta, '00:00:00'::interval)) AS "time", d.destination, s.id AS bus_stop_id, true AS generated FROM ("Departures" d RIGHT JOIN "BusStops" s ON ((d.bus_stop_id = s."references"))) WHERE (s."references" IS NOT NULL);


ALTER TABLE public."Departures_dereferenced" OWNER TO kjntea_omsysv;

--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: kjntea_omsysv
--

CREATE SEQUENCE routes_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.routes_id_seq OWNER TO kjntea_omsysv;

--
-- Name: Routes; Type: TABLE; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE TABLE "Routes" (
    id integer DEFAULT nextval('routes_id_seq'::regclass) NOT NULL,
    name character varying(100) NOT NULL,
    number character varying(5)
);


ALTER TABLE public."Routes" OWNER TO kjntea_omsysv;

--
-- Name: timetables_id_seq; Type: SEQUENCE; Schema: public; Owner: kjntea_omsysv
--

CREATE SEQUENCE timetables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timetables_id_seq OWNER TO kjntea_omsysv;

--
-- Name: Timetables; Type: TABLE; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE TABLE "Timetables" (
    id integer DEFAULT nextval('timetables_id_seq'::regclass) NOT NULL,
    route_id integer NOT NULL,
    name character varying(100) NOT NULL,
    valid_from date NOT NULL,
    valid_to date NOT NULL
);


ALTER TABLE public."Timetables" OWNER TO kjntea_omsysv;

--
-- Name: Routes_and_Timetables; Type: VIEW; Schema: public; Owner: kjntea_omsysv
--

CREATE VIEW "Routes_and_Timetables" AS
SELECT tt.id, tt.name, tt.valid_from, tt.valid_to, r.number AS route_number, r.name AS route_name FROM "Timetables" tt, "Routes" r WHERE (tt.route_id = r.id);


ALTER TABLE public."Routes_and_Timetables" OWNER TO kjntea_omsysv;

--
-- Name: BusStops_pkey; Type: CONSTRAINT; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

ALTER TABLE ONLY "BusStops"
    ADD CONSTRAINT "BusStops_pkey" PRIMARY KEY (id);


--
-- Name: Departures_pkey; Type: CONSTRAINT; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

ALTER TABLE ONLY "Departures"
    ADD CONSTRAINT "Departures_pkey" PRIMARY KEY (id);


--
-- Name: Routes_pkey; Type: CONSTRAINT; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

ALTER TABLE ONLY "Routes"
    ADD CONSTRAINT "Routes_pkey" PRIMARY KEY (id);


--
-- Name: Timetables_pkey; Type: CONSTRAINT; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

ALTER TABLE ONLY "Timetables"
    ADD CONSTRAINT "Timetables_pkey" PRIMARY KEY (id);


--
-- Name: stop_timetable_days_time_dest_uniq; Type: CONSTRAINT; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

ALTER TABLE ONLY "Departures"
    ADD CONSTRAINT stop_timetable_days_time_dest_uniq UNIQUE (bus_stop_id, timetable_id, valid_days, "time", destination);


--
-- Name: fki_BusStops_referances_fkey -> BusStops; Type: INDEX; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE INDEX "fki_BusStops_referances_fkey -> BusStops" ON "BusStops" USING btree ("references");


--
-- Name: idx_BusStops_location; Type: INDEX; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE INDEX "idx_BusStops_location" ON "BusStops" USING gist (location);


--
-- Name: stop_timetable_days_time_dest; Type: INDEX; Schema: public; Owner: kjntea_omsysv; Tablespace: 
--

CREATE UNIQUE INDEX stop_timetable_days_time_dest ON "Departures" USING btree (bus_stop_id, timetable_id, valid_days, "time") WHERE (destination IS NULL);


--
-- Name: busstops_view_ins; Type: RULE; Schema: public; Owner: kjntea_omsysv
--

CREATE RULE busstops_view_ins AS ON INSERT TO "BusStops_to_geometry" DO INSTEAD INSERT INTO "BusStops" (name, location) VALUES (new.name, (new.location)::geography);


--
-- Name: busstops_view_upd; Type: RULE; Schema: public; Owner: kjntea_omsysv
--

CREATE RULE busstops_view_upd AS ON UPDATE TO "BusStops_to_geometry" DO INSTEAD UPDATE "BusStops" SET name = new.name, location = (new.location)::geography WHERE ("BusStops".id = new.id);


--
-- Name: BusStops_references; Type: FK CONSTRAINT; Schema: public; Owner: kjntea_omsysv
--

ALTER TABLE ONLY "BusStops"
    ADD CONSTRAINT "BusStops_references" FOREIGN KEY ("references") REFERENCES "BusStops"(id);


--
-- Name: Departures_busstop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kjntea_omsysv
--

ALTER TABLE ONLY "Departures"
    ADD CONSTRAINT "Departures_busstop_fkey" FOREIGN KEY (bus_stop_id) REFERENCES "BusStops"(id);


--
-- Name: Departures_timetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kjntea_omsysv
--

ALTER TABLE ONLY "Departures"
    ADD CONSTRAINT "Departures_timetable_fkey" FOREIGN KEY (timetable_id) REFERENCES "Timetables"(id);


--
-- Name: Timetables_route_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kjntea_omsysv
--

ALTER TABLE ONLY "Timetables"
    ADD CONSTRAINT "Timetables_route_fkey" FOREIGN KEY (route_id) REFERENCES "Routes"(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

