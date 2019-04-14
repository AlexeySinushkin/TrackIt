--
-- PostgreSQL database dump
--

-- Started on 2009-06-02 21:17:11

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 1294 (class 2612 OID 16386)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 1154 (class 1247 OID 18235)
-- Dependencies: 6 2835
-- Name: breakpoint; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE breakpoint AS (
	func oid,
	linenumber integer,
	targetname text
);


ALTER TYPE public.breakpoint OWNER TO postgres;

--
-- TOC entry 1076 (class 0 OID 0)
-- Name: chkpass; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE chkpass;


--
-- TOC entry 141 (class 1255 OID 16843)
-- Dependencies: 6 1076
-- Name: chkpass_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION chkpass_in(cstring) RETURNS chkpass
    AS '$libdir/chkpass', 'chkpass_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.chkpass_in(cstring) OWNER TO postgres;

--
-- TOC entry 142 (class 1255 OID 16844)
-- Dependencies: 6 1076
-- Name: chkpass_out(chkpass); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION chkpass_out(chkpass) RETURNS cstring
    AS '$libdir/chkpass', 'chkpass_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.chkpass_out(chkpass) OWNER TO postgres;

--
-- TOC entry 1075 (class 1247 OID 16842)
-- Dependencies: 142 6 141
-- Name: chkpass; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE chkpass (
    INTERNALLENGTH = 16,
    INPUT = chkpass_in,
    OUTPUT = chkpass_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.chkpass OWNER TO postgres;

--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 1075
-- Name: TYPE chkpass; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE chkpass IS 'password type with checks';


--
-- TOC entry 788 (class 1255 OID 18584)
-- Dependencies: 6
-- Name: gmtnow(); Type: FUNCTION; Schema: public; Owner: trackit_user
--

CREATE FUNCTION gmtnow() RETURNS timestamp without time zone
    AS $$select now() AT TIME ZONE 'GMT' as result;$$
    LANGUAGE sql STRICT;


ALTER FUNCTION public.gmtnow() OWNER TO trackit_user;

--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 788
-- Name: FUNCTION gmtnow(); Type: COMMENT; Schema: public; Owner: trackit_user
--

COMMENT ON FUNCTION gmtnow() IS 'current GMT';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 2841 (class 1259 OID 18308)
-- Dependencies: 3215 6
-- Name: commoncontent; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE commoncontent (
    id integer NOT NULL,
    parentid bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    classname character varying(50) NOT NULL,
    propertyname character varying(50) NOT NULL,
    cultureid smallint NOT NULL,
    text character varying(400)
);


ALTER TABLE public.commoncontent OWNER TO trackit_user;

--
-- TOC entry 2843 (class 1259 OID 18320)
-- Dependencies: 3217 3218 6
-- Name: companies; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE companies (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    website character varying(100),
    email character varying(100),
    countryid integer,
    province character varying(100),
    zip character varying(30),
    city character varying(100),
    street character varying(100),
    buildnumber character varying(100),
    addressinfo character varying(500),
    photoid bigint,
    photolightid bigint
);


ALTER TABLE public.companies OWNER TO trackit_user;

--
-- TOC entry 2912 (class 1259 OID 35319)
-- Dependencies: 3321 6
-- Name: companyproperties; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE companyproperties (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    companyid integer NOT NULL,
    propertytypeid integer NOT NULL,
    text character varying(200)
);


ALTER TABLE public.companyproperties OWNER TO trackit_user;

--
-- TOC entry 2910 (class 1259 OID 35292)
-- Dependencies: 3318 3319 6
-- Name: companypropertytypes; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE companypropertytypes (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    countryid smallint NOT NULL,
    key character varying(200) NOT NULL,
    propertyname character varying(100) NOT NULL,
    pattern character varying(100) NOT NULL,
    propertytype character varying(100) DEFAULT 'text'::character varying NOT NULL,
    example character varying(200)
);


ALTER TABLE public.companypropertytypes OWNER TO trackit_user;

--
-- TOC entry 2894 (class 1259 OID 18837)
-- Dependencies: 3293 3294 6
-- Name: containermove; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE containermove (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    containerid integer NOT NULL,
    sampledate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    latitude integer,
    longitude integer,
    accuracy smallint
);


ALTER TABLE public.containermove OWNER TO trackit_user;

--
-- TOC entry 2902 (class 1259 OID 26992)
-- Dependencies: 3305 3306 3307 3308 6
-- Name: containers; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE containers (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    registrationnumber character varying(100),
    containertypeid integer,
    info character varying(100),
    ownertype smallint,
    ownerid integer,
    photoid bigint,
    photolightid bigint,
    width integer DEFAULT 0 NOT NULL,
    length integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.containers OWNER TO trackit_user;

--
-- TOC entry 2904 (class 1259 OID 27001)
-- Dependencies: 3310 6
-- Name: containertypes; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE containertypes (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    key character varying(100)
);


ALTER TABLE public.containertypes OWNER TO trackit_user;

--
-- TOC entry 2892 (class 1259 OID 18818)
-- Dependencies: 3291 6
-- Name: containervsdevice; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE containervsdevice (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    deviceid bigint NOT NULL,
    containerid bigint NOT NULL
);


ALTER TABLE public.containervsdevice OWNER TO trackit_user;

--
-- TOC entry 2908 (class 1259 OID 35274)
-- Dependencies: 3316 6
-- Name: countries; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    key character varying(100) NOT NULL
);


ALTER TABLE public.countries OWNER TO trackit_user;

--
-- TOC entry 1079 (class 0 OID 0)
-- Name: cube; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE cube;


--
-- TOC entry 146 (class 1255 OID 16852)
-- Dependencies: 6 1079
-- Name: cube_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_in(cstring) RETURNS cube
    AS '$libdir/cube', 'cube_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_in(cstring) OWNER TO postgres;

--
-- TOC entry 149 (class 1255 OID 16855)
-- Dependencies: 6 1079
-- Name: cube_out(cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_out(cube) RETURNS cstring
    AS '$libdir/cube', 'cube_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_out(cube) OWNER TO postgres;

--
-- TOC entry 1078 (class 1247 OID 16851)
-- Dependencies: 6 149 146
-- Name: cube; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE cube (
    INTERNALLENGTH = variable,
    INPUT = cube_in,
    OUTPUT = cube_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.cube OWNER TO postgres;

--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 1078
-- Name: TYPE cube; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE cube IS 'multi-dimensional cube ''(FLOAT-1, FLOAT-2, ..., FLOAT-N), (FLOAT-1, FLOAT-2, ..., FLOAT-N)''';


--
-- TOC entry 2845 (class 1259 OID 18330)
-- Dependencies: 3220 6
-- Name: cultures; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE cultures (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    culturename character varying(50) NOT NULL
);


ALTER TABLE public.cultures OWNER TO trackit_user;

--
-- TOC entry 1081 (class 1247 OID 16950)
-- Dependencies: 6 2828
-- Name: dblink_pkey_results; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE dblink_pkey_results AS (
	"position" integer,
	colname text
);


ALTER TYPE public.dblink_pkey_results OWNER TO postgres;

--
-- TOC entry 2886 (class 1259 OID 18754)
-- Dependencies: 3279 3280 3281 3282 3283 6
-- Name: devices; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE devices (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    serialnumber integer NOT NULL,
    devicetypeid integer DEFAULT 1,
    containerid bigint,
    x integer DEFAULT 0 NOT NULL,
    y integer DEFAULT 0 NOT NULL,
    z integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.devices OWNER TO trackit_user;

--
-- TOC entry 2890 (class 1259 OID 18797)
-- Dependencies: 3288 3289 6
-- Name: devicetypes; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE devicetypes (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    key character varying(100) DEFAULT ''::character varying
);


ALTER TABLE public.devicetypes OWNER TO trackit_user;

--
-- TOC entry 1100 (class 0 OID 0)
-- Name: ean13; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ean13;


--
-- TOC entry 311 (class 1255 OID 17160)
-- Dependencies: 6 1100
-- Name: ean13_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ean13_in(cstring) RETURNS ean13
    AS '$libdir/isn', 'ean13_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ean13_in(cstring) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 17161)
-- Dependencies: 6 1100
-- Name: ean13_out(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ean13_out(ean13) RETURNS cstring
    AS '$libdir/isn', 'ean13_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ean13_out(ean13) OWNER TO postgres;

--
-- TOC entry 1099 (class 1247 OID 17159)
-- Dependencies: 311 6 312
-- Name: ean13; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ean13 (
    INTERNALLENGTH = 8,
    INPUT = ean13_in,
    OUTPUT = public.ean13_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.ean13 OWNER TO postgres;

--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 1099
-- Name: TYPE ean13; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE ean13 IS 'International European Article Number (EAN13)';


--
-- TOC entry 2896 (class 1259 OID 26946)
-- Dependencies: 3296 3297 6
-- Name: events; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE events (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    actortypeid smallint,
    actorid bigint,
    eventtypeid smallint NOT NULL,
    eventdate timestamp without time zone DEFAULT gmtnow(),
    passivetypeid smallint NOT NULL,
    passiveid bigint,
    sessionuserid integer
);


ALTER TABLE public.events OWNER TO trackit_user;

--
-- TOC entry 2898 (class 1259 OID 26955)
-- Dependencies: 3299 3300 6
-- Name: eventtypes; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE eventtypes (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    key character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.eventtypes OWNER TO trackit_user;

--
-- TOC entry 2913 (class 1259 OID 43376)
-- Dependencies: 3000 6
-- Name: eventsview; Type: VIEW; Schema: public; Owner: trackit_user
--

CREATE VIEW eventsview AS
    SELECT events.id, events.createdate, events.actortypeid, events.actorid, events.eventtypeid, eventtypes.key AS eventkey, events.eventdate, events.passivetypeid, events.passiveid, events.sessionuserid FROM (events LEFT JOIN eventtypes ON ((events.eventtypeid = eventtypes.id)));


ALTER TABLE public.eventsview OWNER TO trackit_user;

--
-- TOC entry 2914 (class 1259 OID 43384)
-- Dependencies: 3001 6
-- Name: eventtypesview; Type: VIEW; Schema: public; Owner: trackit_user
--

CREATE VIEW eventtypesview AS
    SELECT eventtypes.id, eventtypes.createdate, eventtypes.key, ename.text AS name, ename.cultureid FROM (eventtypes LEFT JOIN commoncontent ename ON ((((eventtypes.id = ename.parentid) AND ((ename.classname)::text = 'EventType'::text)) AND ((ename.propertyname)::text = 'Name'::text))));


ALTER TABLE public.eventtypesview OWNER TO trackit_user;

--
-- TOC entry 2906 (class 1259 OID 35147)
-- Dependencies: 3312 3313 3314 6
-- Name: files; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE files (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    guid character varying(200) NOT NULL,
    contenttype character varying(100) DEFAULT ''::character varying,
    filename character varying(200) DEFAULT ''::character varying,
    content bytea
);


ALTER TABLE public.files OWNER TO trackit_user;

--
-- TOC entry 2875 (class 1259 OID 18536)
-- Dependencies: 3263 6
-- Name: formatsdate; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE formatsdate (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    format character varying(50) NOT NULL
);


ALTER TABLE public.formatsdate OWNER TO trackit_user;

--
-- TOC entry 2873 (class 1259 OID 18527)
-- Dependencies: 3261 6
-- Name: formatsdistance; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE formatsdistance (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    format character varying(50) NOT NULL
);


ALTER TABLE public.formatsdistance OWNER TO trackit_user;

--
-- TOC entry 2871 (class 1259 OID 18518)
-- Dependencies: 3259 6
-- Name: formatstemperature; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE formatstemperature (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    format character varying(50) NOT NULL
);


ALTER TABLE public.formatstemperature OWNER TO trackit_user;

--
-- TOC entry 2869 (class 1259 OID 18509)
-- Dependencies: 3257 6
-- Name: formatstime; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE formatstime (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    format character varying(50) NOT NULL
);


ALTER TABLE public.formatstime OWNER TO trackit_user;

--
-- TOC entry 1156 (class 1247 OID 18238)
-- Dependencies: 6 2836
-- Name: frame; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE frame AS (
	level integer,
	targetname text,
	func oid,
	linenumber integer,
	args text
);


ALTER TYPE public.frame OWNER TO postgres;

--
-- TOC entry 1067 (class 0 OID 0)
-- Name: gbtreekey16; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey16;


--
-- TOC entry 24 (class 1255 OID 16412)
-- Dependencies: 6 1067
-- Name: gbtreekey16_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey16_in(cstring) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbtreekey_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey16_in(cstring) OWNER TO postgres;

--
-- TOC entry 25 (class 1255 OID 16413)
-- Dependencies: 6 1067
-- Name: gbtreekey16_out(gbtreekey16); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey16_out(gbtreekey16) RETURNS cstring
    AS '$libdir/btree_gist', 'gbtreekey_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey16_out(gbtreekey16) OWNER TO postgres;

--
-- TOC entry 1066 (class 1247 OID 16411)
-- Dependencies: 25 24 6
-- Name: gbtreekey16; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey16 (
    INTERNALLENGTH = 16,
    INPUT = gbtreekey16_in,
    OUTPUT = gbtreekey16_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.gbtreekey16 OWNER TO postgres;

--
-- TOC entry 1070 (class 0 OID 0)
-- Name: gbtreekey32; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey32;


--
-- TOC entry 26 (class 1255 OID 16416)
-- Dependencies: 6 1070
-- Name: gbtreekey32_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey32_in(cstring) RETURNS gbtreekey32
    AS '$libdir/btree_gist', 'gbtreekey_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey32_in(cstring) OWNER TO postgres;

--
-- TOC entry 27 (class 1255 OID 16417)
-- Dependencies: 6 1070
-- Name: gbtreekey32_out(gbtreekey32); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey32_out(gbtreekey32) RETURNS cstring
    AS '$libdir/btree_gist', 'gbtreekey_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey32_out(gbtreekey32) OWNER TO postgres;

--
-- TOC entry 1069 (class 1247 OID 16415)
-- Dependencies: 26 6 27
-- Name: gbtreekey32; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey32 (
    INTERNALLENGTH = 32,
    INPUT = gbtreekey32_in,
    OUTPUT = gbtreekey32_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.gbtreekey32 OWNER TO postgres;

--
-- TOC entry 1025 (class 0 OID 0)
-- Name: gbtreekey4; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey4;


--
-- TOC entry 20 (class 1255 OID 16404)
-- Dependencies: 6 1025
-- Name: gbtreekey4_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey4_in(cstring) RETURNS gbtreekey4
    AS '$libdir/btree_gist', 'gbtreekey_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey4_in(cstring) OWNER TO postgres;

--
-- TOC entry 21 (class 1255 OID 16405)
-- Dependencies: 6 1025
-- Name: gbtreekey4_out(gbtreekey4); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey4_out(gbtreekey4) RETURNS cstring
    AS '$libdir/btree_gist', 'gbtreekey_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey4_out(gbtreekey4) OWNER TO postgres;

--
-- TOC entry 1024 (class 1247 OID 16403)
-- Dependencies: 20 6 21
-- Name: gbtreekey4; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey4 (
    INTERNALLENGTH = 4,
    INPUT = gbtreekey4_in,
    OUTPUT = gbtreekey4_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.gbtreekey4 OWNER TO postgres;

--
-- TOC entry 1064 (class 0 OID 0)
-- Name: gbtreekey8; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey8;


--
-- TOC entry 22 (class 1255 OID 16408)
-- Dependencies: 6 1064
-- Name: gbtreekey8_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey8_in(cstring) RETURNS gbtreekey8
    AS '$libdir/btree_gist', 'gbtreekey_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey8_in(cstring) OWNER TO postgres;

--
-- TOC entry 23 (class 1255 OID 16409)
-- Dependencies: 6 1064
-- Name: gbtreekey8_out(gbtreekey8); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey8_out(gbtreekey8) RETURNS cstring
    AS '$libdir/btree_gist', 'gbtreekey_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey8_out(gbtreekey8) OWNER TO postgres;

--
-- TOC entry 1063 (class 1247 OID 16407)
-- Dependencies: 23 6 22
-- Name: gbtreekey8; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey8 (
    INTERNALLENGTH = 8,
    INPUT = gbtreekey8_in,
    OUTPUT = gbtreekey8_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.gbtreekey8 OWNER TO postgres;

--
-- TOC entry 1073 (class 0 OID 0)
-- Name: gbtreekey_var; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey_var;


--
-- TOC entry 28 (class 1255 OID 16420)
-- Dependencies: 6 1073
-- Name: gbtreekey_var_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey_var_in(cstring) RETURNS gbtreekey_var
    AS '$libdir/btree_gist', 'gbtreekey_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey_var_in(cstring) OWNER TO postgres;

--
-- TOC entry 29 (class 1255 OID 16421)
-- Dependencies: 6 1073
-- Name: gbtreekey_var_out(gbtreekey_var); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbtreekey_var_out(gbtreekey_var) RETURNS cstring
    AS '$libdir/btree_gist', 'gbtreekey_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbtreekey_var_out(gbtreekey_var) OWNER TO postgres;

--
-- TOC entry 1072 (class 1247 OID 16419)
-- Dependencies: 6 28 29
-- Name: gbtreekey_var; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gbtreekey_var (
    INTERNALLENGTH = variable,
    INPUT = gbtreekey_var_in,
    OUTPUT = gbtreekey_var_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.gbtreekey_var OWNER TO postgres;

--
-- TOC entry 1091 (class 0 OID 0)
-- Name: ghstore; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ghstore;


--
-- TOC entry 251 (class 1255 OID 17012)
-- Dependencies: 6 1091
-- Name: ghstore_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_in(cstring) RETURNS ghstore
    AS '$libdir/hstore', 'ghstore_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ghstore_in(cstring) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 17013)
-- Dependencies: 6 1091
-- Name: ghstore_out(ghstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_out(ghstore) RETURNS cstring
    AS '$libdir/hstore', 'ghstore_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ghstore_out(ghstore) OWNER TO postgres;

--
-- TOC entry 1090 (class 1247 OID 17011)
-- Dependencies: 6 251 252
-- Name: ghstore; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ghstore (
    INTERNALLENGTH = variable,
    INPUT = ghstore_in,
    OUTPUT = ghstore_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.ghstore OWNER TO postgres;

--
-- TOC entry 2867 (class 1259 OID 18496)
-- Dependencies: 3255 6
-- Name: gpspoints; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE gpspoints (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    name character varying(100) NOT NULL,
    latitude integer NOT NULL,
    longitude integer NOT NULL
);


ALTER TABLE public.gpspoints OWNER TO trackit_user;

--
-- TOC entry 1143 (class 0 OID 0)
-- Name: gtrgm; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gtrgm;


--
-- TOC entry 641 (class 1255 OID 18035)
-- Dependencies: 6 1143
-- Name: gtrgm_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_in(cstring) RETURNS gtrgm
    AS '$libdir/pg_trgm', 'gtrgm_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.gtrgm_in(cstring) OWNER TO postgres;

--
-- TOC entry 642 (class 1255 OID 18036)
-- Dependencies: 6 1143
-- Name: gtrgm_out(gtrgm); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_out(gtrgm) RETURNS cstring
    AS '$libdir/pg_trgm', 'gtrgm_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.gtrgm_out(gtrgm) OWNER TO postgres;

--
-- TOC entry 1142 (class 1247 OID 18034)
-- Dependencies: 6 642 641
-- Name: gtrgm; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gtrgm (
    INTERNALLENGTH = variable,
    INPUT = gtrgm_in,
    OUTPUT = gtrgm_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.gtrgm OWNER TO postgres;

--
-- TOC entry 1088 (class 0 OID 0)
-- Name: hstore; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE hstore;


--
-- TOC entry 234 (class 1255 OID 16985)
-- Dependencies: 6 1088
-- Name: hstore_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hstore_in(cstring) RETURNS hstore
    AS '$libdir/hstore', 'hstore_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.hstore_in(cstring) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16986)
-- Dependencies: 6 1088
-- Name: hstore_out(hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hstore_out(hstore) RETURNS cstring
    AS '$libdir/hstore', 'hstore_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.hstore_out(hstore) OWNER TO postgres;

--
-- TOC entry 1087 (class 1247 OID 16984)
-- Dependencies: 6 235 234
-- Name: hstore; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE hstore (
    INTERNALLENGTH = variable,
    INPUT = hstore_in,
    OUTPUT = hstore_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.hstore OWNER TO postgres;

--
-- TOC entry 1097 (class 0 OID 0)
-- Name: intbig_gkey; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE intbig_gkey;


--
-- TOC entry 300 (class 1255 OID 17118)
-- Dependencies: 6 1097
-- Name: _intbig_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _intbig_in(cstring) RETURNS intbig_gkey
    AS '$libdir/_int', '_intbig_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._intbig_in(cstring) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 17119)
-- Dependencies: 6 1097
-- Name: _intbig_out(intbig_gkey); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _intbig_out(intbig_gkey) RETURNS cstring
    AS '$libdir/_int', '_intbig_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._intbig_out(intbig_gkey) OWNER TO postgres;

--
-- TOC entry 1096 (class 1247 OID 17117)
-- Dependencies: 6 301 300
-- Name: intbig_gkey; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE intbig_gkey (
    INTERNALLENGTH = variable,
    INPUT = _intbig_in,
    OUTPUT = _intbig_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.intbig_gkey OWNER TO postgres;

--
-- TOC entry 1112 (class 0 OID 0)
-- Name: isbn; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE isbn;


--
-- TOC entry 319 (class 1255 OID 17176)
-- Dependencies: 6 1112
-- Name: isbn_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isbn_in(cstring) RETURNS isbn
    AS '$libdir/isn', 'isbn_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isbn_in(cstring) OWNER TO postgres;

--
-- TOC entry 320 (class 1255 OID 17177)
-- Dependencies: 6 1112
-- Name: isn_out(isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isn_out(isbn) RETURNS cstring
    AS '$libdir/isn', 'isn_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isn_out(isbn) OWNER TO postgres;

--
-- TOC entry 1111 (class 1247 OID 17175)
-- Dependencies: 319 320 6
-- Name: isbn; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE isbn (
    INTERNALLENGTH = 8,
    INPUT = isbn_in,
    OUTPUT = public.isn_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.isbn OWNER TO postgres;

--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 1111
-- Name: TYPE isbn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE isbn IS 'International Standard Book Number (ISBN)';


--
-- TOC entry 1103 (class 0 OID 0)
-- Name: isbn13; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE isbn13;


--
-- TOC entry 314 (class 1255 OID 17165)
-- Dependencies: 6 1103
-- Name: ean13_out(isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ean13_out(isbn13) RETURNS cstring
    AS '$libdir/isn', 'ean13_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ean13_out(isbn13) OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 17164)
-- Dependencies: 6 1103
-- Name: isbn13_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isbn13_in(cstring) RETURNS isbn13
    AS '$libdir/isn', 'isbn_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isbn13_in(cstring) OWNER TO postgres;

--
-- TOC entry 1102 (class 1247 OID 17163)
-- Dependencies: 313 314 6
-- Name: isbn13; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE isbn13 (
    INTERNALLENGTH = 8,
    INPUT = isbn13_in,
    OUTPUT = public.ean13_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.isbn13 OWNER TO postgres;

--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 1102
-- Name: TYPE isbn13; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE isbn13 IS 'International Standard Book Number 13 (ISBN13)';


--
-- TOC entry 1115 (class 0 OID 0)
-- Name: ismn; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ismn;


--
-- TOC entry 321 (class 1255 OID 17180)
-- Dependencies: 6 1115
-- Name: ismn_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ismn_in(cstring) RETURNS ismn
    AS '$libdir/isn', 'ismn_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ismn_in(cstring) OWNER TO postgres;

--
-- TOC entry 322 (class 1255 OID 17181)
-- Dependencies: 6 1115
-- Name: isn_out(ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isn_out(ismn) RETURNS cstring
    AS '$libdir/isn', 'isn_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isn_out(ismn) OWNER TO postgres;

--
-- TOC entry 1114 (class 1247 OID 17179)
-- Dependencies: 6 321 322
-- Name: ismn; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ismn (
    INTERNALLENGTH = 8,
    INPUT = ismn_in,
    OUTPUT = public.isn_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.ismn OWNER TO postgres;

--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 1114
-- Name: TYPE ismn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE ismn IS 'International Standard Music Number (ISMN)';


--
-- TOC entry 1106 (class 0 OID 0)
-- Name: ismn13; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ismn13;


--
-- TOC entry 316 (class 1255 OID 17169)
-- Dependencies: 6 1106
-- Name: ean13_out(ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ean13_out(ismn13) RETURNS cstring
    AS '$libdir/isn', 'ean13_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ean13_out(ismn13) OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 17168)
-- Dependencies: 6 1106
-- Name: ismn13_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ismn13_in(cstring) RETURNS ismn13
    AS '$libdir/isn', 'ismn_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ismn13_in(cstring) OWNER TO postgres;

--
-- TOC entry 1105 (class 1247 OID 17167)
-- Dependencies: 316 6 315
-- Name: ismn13; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ismn13 (
    INTERNALLENGTH = 8,
    INPUT = ismn13_in,
    OUTPUT = public.ean13_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.ismn13 OWNER TO postgres;

--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 1105
-- Name: TYPE ismn13; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE ismn13 IS 'International Standard Music Number 13 (ISMN13)';


--
-- TOC entry 1118 (class 0 OID 0)
-- Name: issn; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE issn;


--
-- TOC entry 324 (class 1255 OID 17185)
-- Dependencies: 6 1118
-- Name: isn_out(issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isn_out(issn) RETURNS cstring
    AS '$libdir/isn', 'isn_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isn_out(issn) OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 17184)
-- Dependencies: 6 1118
-- Name: issn_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION issn_in(cstring) RETURNS issn
    AS '$libdir/isn', 'issn_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.issn_in(cstring) OWNER TO postgres;

--
-- TOC entry 1117 (class 1247 OID 17183)
-- Dependencies: 323 6 324
-- Name: issn; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE issn (
    INTERNALLENGTH = 8,
    INPUT = issn_in,
    OUTPUT = public.isn_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.issn OWNER TO postgres;

--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 1117
-- Name: TYPE issn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE issn IS 'International Standard Serial Number (ISSN)';


--
-- TOC entry 1109 (class 0 OID 0)
-- Name: issn13; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE issn13;


--
-- TOC entry 318 (class 1255 OID 17173)
-- Dependencies: 6 1109
-- Name: ean13_out(issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ean13_out(issn13) RETURNS cstring
    AS '$libdir/isn', 'ean13_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ean13_out(issn13) OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 17172)
-- Dependencies: 6 1109
-- Name: issn13_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION issn13_in(cstring) RETURNS issn13
    AS '$libdir/isn', 'issn_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.issn13_in(cstring) OWNER TO postgres;

--
-- TOC entry 1108 (class 1247 OID 17171)
-- Dependencies: 317 318 6
-- Name: issn13; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE issn13 (
    INTERNALLENGTH = 8,
    INPUT = issn13_in,
    OUTPUT = public.ean13_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.issn13 OWNER TO postgres;

--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 1108
-- Name: TYPE issn13; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE issn13 IS 'International Standard Serial Number 13 (ISSN13)';


--
-- TOC entry 2865 (class 1259 OID 18487)
-- Dependencies: 3253 6
-- Name: iuservsiuser; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE iuservsiuser (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    iusertype smallint NOT NULL,
    iuserid integer NOT NULL,
    relationiusertype smallint NOT NULL,
    relationiuserid integer NOT NULL
);


ALTER TABLE public.iuservsiuser OWNER TO trackit_user;

--
-- TOC entry 2861 (class 1259 OID 18461)
-- Dependencies: 3249 3250 6
-- Name: location; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    name character varying(30) DEFAULT ''::character varying NOT NULL,
    latitude integer NOT NULL,
    longitude integer NOT NULL,
    photoid bigint,
    photolightid bigint,
    email character varying(100),
    countryid integer,
    province character varying(100),
    zip character varying(30),
    city character varying(100),
    street character varying(100),
    buildnumber character varying(100),
    addressinfo character varying(500),
    phone character varying(100)
);


ALTER TABLE public.location OWNER TO trackit_user;

--
-- TOC entry 2859 (class 1259 OID 18451)
-- Dependencies: 3246 3247 6
-- Name: locationvsuser; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE locationvsuser (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    locationid integer NOT NULL,
    iusertype smallint DEFAULT 0 NOT NULL,
    iuserid integer NOT NULL
);


ALTER TABLE public.locationvsuser OWNER TO trackit_user;

--
-- TOC entry 1128 (class 0 OID 0)
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE lquery;


--
-- TOC entry 589 (class 1255 OID 17888)
-- Dependencies: 6 1128
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    AS '$libdir/ltree', 'lquery_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.lquery_in(cstring) OWNER TO postgres;

--
-- TOC entry 590 (class 1255 OID 17889)
-- Dependencies: 6 1128
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    AS '$libdir/ltree', 'lquery_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.lquery_out(lquery) OWNER TO postgres;

--
-- TOC entry 1127 (class 1247 OID 17887)
-- Dependencies: 6 589 590
-- Name: lquery; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE lquery (
    INTERNALLENGTH = variable,
    INPUT = lquery_in,
    OUTPUT = lquery_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.lquery OWNER TO postgres;

--
-- TOC entry 1125 (class 0 OID 0)
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ltree;


--
-- TOC entry 558 (class 1255 OID 17834)
-- Dependencies: 6 1125
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    AS '$libdir/ltree', 'ltree_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ltree_in(cstring) OWNER TO postgres;

--
-- TOC entry 559 (class 1255 OID 17835)
-- Dependencies: 6 1125
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    AS '$libdir/ltree', 'ltree_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ltree_out(ltree) OWNER TO postgres;

--
-- TOC entry 1124 (class 1247 OID 17833)
-- Dependencies: 559 558 6
-- Name: ltree; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ltree (
    INTERNALLENGTH = variable,
    INPUT = ltree_in,
    OUTPUT = ltree_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.ltree OWNER TO postgres;

--
-- TOC entry 1134 (class 0 OID 0)
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ltree_gist;


--
-- TOC entry 599 (class 1255 OID 17914)
-- Dependencies: 6 1134
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    AS '$libdir/ltree', 'ltree_gist_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ltree_gist_in(cstring) OWNER TO postgres;

--
-- TOC entry 600 (class 1255 OID 17915)
-- Dependencies: 6 1134
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    AS '$libdir/ltree', 'ltree_gist_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ltree_gist_out(ltree_gist) OWNER TO postgres;

--
-- TOC entry 1133 (class 1247 OID 17913)
-- Dependencies: 6 600 599
-- Name: ltree_gist; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ltree_gist (
    INTERNALLENGTH = variable,
    INPUT = ltree_gist_in,
    OUTPUT = ltree_gist_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.ltree_gist OWNER TO postgres;

--
-- TOC entry 1131 (class 0 OID 0)
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ltxtquery;


--
-- TOC entry 595 (class 1255 OID 17904)
-- Dependencies: 6 1131
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    AS '$libdir/ltree', 'ltxtq_in'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ltxtq_in(cstring) OWNER TO postgres;

--
-- TOC entry 596 (class 1255 OID 17905)
-- Dependencies: 6 1131
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    AS '$libdir/ltree', 'ltxtq_out'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ltxtq_out(ltxtquery) OWNER TO postgres;

--
-- TOC entry 1130 (class 1247 OID 17903)
-- Dependencies: 596 6 595
-- Name: ltxtquery; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE ltxtquery (
    INTERNALLENGTH = variable,
    INPUT = ltxtq_in,
    OUTPUT = ltxtq_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.ltxtquery OWNER TO postgres;

--
-- TOC entry 2863 (class 1259 OID 18471)
-- Dependencies: 6
-- Name: messages; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    message character varying(200) NOT NULL
);


ALTER TABLE public.messages OWNER TO trackit_user;

--
-- TOC entry 2900 (class 1259 OID 26980)
-- Dependencies: 3302 3303 6
-- Name: objecttypes; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE objecttypes (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    classname character varying(100) DEFAULT ''::character varying NOT NULL,
    nameproperty character varying(100)
);


ALTER TABLE public.objecttypes OWNER TO trackit_user;

--
-- TOC entry 790 (class 1255 OID 18013)
-- Dependencies: 6
-- Name: pg_buffercache_pages(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pg_buffercache_pages() RETURNS SETOF record
    AS '$libdir/pg_buffercache', 'pg_buffercache_pages'
    LANGUAGE c;


ALTER FUNCTION public.pg_buffercache_pages() OWNER TO postgres;

--
-- TOC entry 2829 (class 1259 OID 18014)
-- Dependencies: 2996 6
-- Name: pg_buffercache; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pg_buffercache AS
    SELECT p.bufferid, p.relfilenode, p.reltablespace, p.reldatabase, p.relblocknumber, p.isdirty, p.usagecount FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relblocknumber bigint, isdirty boolean, usagecount smallint);


ALTER TABLE public.pg_buffercache OWNER TO postgres;

--
-- TOC entry 635 (class 1255 OID 18018)
-- Dependencies: 6
-- Name: pg_freespacemap_pages(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pg_freespacemap_pages() RETURNS SETOF record
    AS '$libdir/pg_freespacemap', 'pg_freespacemap_pages'
    LANGUAGE c;


ALTER FUNCTION public.pg_freespacemap_pages() OWNER TO postgres;

--
-- TOC entry 2830 (class 1259 OID 18020)
-- Dependencies: 2997 6
-- Name: pg_freespacemap_pages; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pg_freespacemap_pages AS
    SELECT p.reltablespace, p.reldatabase, p.relfilenode, p.relblocknumber, p.bytes FROM pg_freespacemap_pages() p(reltablespace oid, reldatabase oid, relfilenode oid, relblocknumber bigint, bytes integer);


ALTER TABLE public.pg_freespacemap_pages OWNER TO postgres;

--
-- TOC entry 634 (class 1255 OID 18019)
-- Dependencies: 6
-- Name: pg_freespacemap_relations(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pg_freespacemap_relations() RETURNS SETOF record
    AS '$libdir/pg_freespacemap', 'pg_freespacemap_relations'
    LANGUAGE c;


ALTER FUNCTION public.pg_freespacemap_relations() OWNER TO postgres;

--
-- TOC entry 2831 (class 1259 OID 18024)
-- Dependencies: 2998 6
-- Name: pg_freespacemap_relations; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pg_freespacemap_relations AS
    SELECT p.reltablespace, p.reldatabase, p.relfilenode, p.avgrequest, p.interestingpages, p.storedpages, p.nextpage FROM pg_freespacemap_relations() p(reltablespace oid, reldatabase oid, relfilenode oid, avgrequest integer, interestingpages integer, storedpages integer, nextpage integer);


ALTER TABLE public.pg_freespacemap_relations OWNER TO postgres;

--
-- TOC entry 1162 (class 1247 OID 18247)
-- Dependencies: 6 2839
-- Name: proxyinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE proxyinfo AS (
	serverversionstr text,
	serverversionnum integer,
	proxyapiver integer,
	serverprocessid integer
);


ALTER TYPE public.proxyinfo OWNER TO postgres;

--
-- TOC entry 1094 (class 0 OID 0)
-- Name: query_int; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE query_int;


--
-- TOC entry 266 (class 1255 OID 17050)
-- Dependencies: 6 1094
-- Name: bqarr_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bqarr_in(cstring) RETURNS query_int
    AS '$libdir/_int', 'bqarr_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bqarr_in(cstring) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 17051)
-- Dependencies: 6 1094
-- Name: bqarr_out(query_int); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bqarr_out(query_int) RETURNS cstring
    AS '$libdir/_int', 'bqarr_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bqarr_out(query_int) OWNER TO postgres;

--
-- TOC entry 1093 (class 1247 OID 17049)
-- Dependencies: 267 266 6
-- Name: query_int; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE query_int (
    INTERNALLENGTH = variable,
    INPUT = bqarr_in,
    OUTPUT = bqarr_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.query_int OWNER TO postgres;

--
-- TOC entry 2857 (class 1259 OID 18442)
-- Dependencies: 3244 6
-- Name: routes; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE routes (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL
);


ALTER TABLE public.routes OWNER TO trackit_user;

--
-- TOC entry 1146 (class 0 OID 0)
-- Name: seg; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE seg;


--
-- TOC entry 690 (class 1255 OID 18103)
-- Dependencies: 6 1146
-- Name: seg_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_in(cstring) RETURNS seg
    AS '$libdir/seg', 'seg_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_in(cstring) OWNER TO postgres;

--
-- TOC entry 691 (class 1255 OID 18104)
-- Dependencies: 6 1146
-- Name: seg_out(seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_out(seg) RETURNS cstring
    AS '$libdir/seg', 'seg_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_out(seg) OWNER TO postgres;

--
-- TOC entry 1145 (class 1247 OID 18102)
-- Dependencies: 6 690 691
-- Name: seg; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE seg (
    INTERNALLENGTH = 12,
    INPUT = seg_in,
    OUTPUT = seg_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.seg OWNER TO postgres;

--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 1145
-- Name: TYPE seg; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE seg IS 'floating point interval ''FLOAT .. FLOAT'', ''.. FLOAT'', ''FLOAT ..'' or ''FLOAT''';


--
-- TOC entry 2888 (class 1259 OID 18764)
-- Dependencies: 3285 3286 6
-- Name: sensorsdata; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE sensorsdata (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    sensorid integer NOT NULL,
    sampledate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    samplevalue integer
);


ALTER TABLE public.sensorsdata OWNER TO trackit_user;

--
-- TOC entry 1148 (class 1247 OID 18193)
-- Dependencies: 6 2832
-- Name: tablefunc_crosstab_2; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_2 AS (
	row_name text,
	category_1 text,
	category_2 text
);


ALTER TYPE public.tablefunc_crosstab_2 OWNER TO postgres;

--
-- TOC entry 1150 (class 1247 OID 18196)
-- Dependencies: 6 2833
-- Name: tablefunc_crosstab_3; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_3 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text
);


ALTER TYPE public.tablefunc_crosstab_3 OWNER TO postgres;

--
-- TOC entry 1152 (class 1247 OID 18199)
-- Dependencies: 6 2834
-- Name: tablefunc_crosstab_4; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_4 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text,
	category_4 text
);


ALTER TYPE public.tablefunc_crosstab_4 OWNER TO postgres;

--
-- TOC entry 1158 (class 1247 OID 18241)
-- Dependencies: 6 2837
-- Name: targetinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE targetinfo AS (
	target oid,
	schema oid,
	nargs integer,
	argtypes oidvector,
	targetname name,
	argmodes "char"[],
	argnames text[],
	targetlang oid,
	fqname text,
	returnsset boolean,
	returntype oid
);


ALTER TYPE public.targetinfo OWNER TO postgres;

--
-- TOC entry 2882 (class 1259 OID 18668)
-- Dependencies: 3269 3270 3271 3272 3273 3274 6
-- Name: timezones; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE timezones (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    offsethours smallint DEFAULT 0 NOT NULL,
    offsetminutes smallint DEFAULT 0 NOT NULL,
    isdaylightsupports smallint DEFAULT 0 NOT NULL,
    timezoneid character varying(100) DEFAULT ' '::character varying NOT NULL,
    display boolean DEFAULT false NOT NULL
);


ALTER TABLE public.timezones OWNER TO trackit_user;

--
-- TOC entry 2855 (class 1259 OID 18433)
-- Dependencies: 3242 6
-- Name: trackcontrolcheckpoints; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE trackcontrolcheckpoints (
    id bigint NOT NULL,
    trackid bigint,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    coordinatetype smallint NOT NULL,
    coordinateid bigint NOT NULL,
    expecteddatefrom timestamp without time zone NOT NULL,
    expecteddateto timestamp without time zone NOT NULL
);


ALTER TABLE public.trackcontrolcheckpoints OWNER TO trackit_user;

--
-- TOC entry 2878 (class 1259 OID 18638)
-- Dependencies: 2999 6
-- Name: trackcontrolcheckpointsview; Type: VIEW; Schema: public; Owner: trackit_user
--

CREATE VIEW trackcontrolcheckpointsview AS
    SELECT cp.id, cp.trackid, cp.createdate, cp.expecteddatefrom, cp.expecteddateto, CASE WHEN (cp.coordinatetype = (1)::smallint) THEN realties.name WHEN (cp.coordinatetype = (2)::smallint) THEN gpspoints.name ELSE NULL::character varying END AS name, CASE WHEN (cp.coordinatetype = (1)::smallint) THEN realties.latitude WHEN (cp.coordinatetype = (2)::smallint) THEN gpspoints.latitude ELSE NULL::integer END AS latitude, CASE WHEN (cp.coordinatetype = (1)::smallint) THEN realties.longitude WHEN (cp.coordinatetype = (2)::smallint) THEN gpspoints.longitude ELSE NULL::integer END AS longitude FROM ((trackcontrolcheckpoints cp LEFT JOIN location realties ON (((cp.coordinatetype = (1)::smallint) AND (cp.coordinateid = realties.id)))) LEFT JOIN gpspoints ON (((cp.coordinatetype = (2)::smallint) AND (cp.coordinateid = gpspoints.id))));


ALTER TABLE public.trackcontrolcheckpointsview OWNER TO trackit_user;

--
-- TOC entry 2853 (class 1259 OID 18425)
-- Dependencies: 3240 6
-- Name: trackcontroltemperatures; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE trackcontroltemperatures (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    trackid bigint NOT NULL,
    rangefrom smallint,
    rangeto smallint
);


ALTER TABLE public.trackcontroltemperatures OWNER TO trackit_user;

--
-- TOC entry 2880 (class 1259 OID 18654)
-- Dependencies: 3267 6
-- Name: trackdates; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE trackdates (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL
);


ALTER TABLE public.trackdates OWNER TO trackit_user;

--
-- TOC entry 2851 (class 1259 OID 18414)
-- Dependencies: 3235 3236 3237 3238 6
-- Name: tracks; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE tracks (
    id bigint NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    containerid integer DEFAULT 0,
    sendertype smallint,
    senderid integer,
    carriertype smallint,
    carrierid integer,
    recipienttype smallint,
    recipientid integer,
    startcheckpointid integer,
    stopcheckpointid integer,
    code character varying(30) DEFAULT ''::character varying NOT NULL,
    startdate timestamp without time zone,
    stopdate timestamp without time zone,
    trackstatusid integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.tracks OWNER TO trackit_user;

--
-- TOC entry 2884 (class 1259 OID 18732)
-- Dependencies: 3276 3277 6
-- Name: trackstatuses; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE trackstatuses (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    keyname character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.trackstatuses OWNER TO trackit_user;

--
-- TOC entry 2849 (class 1259 OID 18384)
-- Dependencies: 3225 3226 3227 3228 3229 3230 3231 3232 3233 6
-- Name: users; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    login character varying(20) NOT NULL,
    password character varying(50) NOT NULL,
    formatdateid smallint DEFAULT 1 NOT NULL,
    formattimeid smallint DEFAULT 1 NOT NULL,
    formatdistanceid smallint DEFAULT 1 NOT NULL,
    formattemperatureid smallint DEFAULT 1 NOT NULL,
    firstname character varying(100) DEFAULT ''::character varying NOT NULL,
    lastname character varying(100) DEFAULT ''::character varying NOT NULL,
    middlename character varying(100),
    timezoneid smallint DEFAULT 2 NOT NULL,
    email character varying(100),
    isadmin boolean DEFAULT false NOT NULL,
    photoid bigint,
    photolightid bigint
);


ALTER TABLE public.users OWNER TO trackit_user;

--
-- TOC entry 2919 (class 1259 OID 59936)
-- Dependencies: 3002 6
-- Name: tracksview; Type: VIEW; Schema: public; Owner: trackit_user
--

CREATE VIEW tracksview AS
    SELECT tracks.id, tracks.createdate, tracks.containerid, tracks.sendertype, tracks.senderid, tracks.carriertype, tracks.carrierid, tracks.recipienttype, tracks.recipientid, tracks.startcheckpointid, tracks.stopcheckpointid, tracks.code, CASE WHEN (tracks.sendertype = (1)::smallint) THEN companies_sender.name WHEN (tracks.sendertype = (2)::smallint) THEN users_sender.login ELSE NULL::character varying END AS sendername, CASE WHEN (tracks.carriertype = (1)::smallint) THEN companies_carrier.name WHEN (tracks.carriertype = (2)::smallint) THEN users_carrier.login ELSE NULL::character varying END AS carriername, CASE WHEN (tracks.recipienttype = (1)::smallint) THEN companies_recipient.name WHEN (tracks.recipienttype = (2)::smallint) THEN users_recipient.login ELSE NULL::character varying END AS recipientname, containers.registrationnumber AS containername, startpoint.name AS startpointname, stoppoint.name AS stoppointname, tracks.startdate, tracks.stopdate FROM (((((((((tracks LEFT JOIN companies companies_sender ON (((tracks.sendertype = (1)::smallint) AND (tracks.senderid = companies_sender.id)))) LEFT JOIN users users_sender ON (((tracks.sendertype = (2)::smallint) AND (tracks.senderid = users_sender.id)))) LEFT JOIN companies companies_carrier ON (((tracks.carriertype = (1)::smallint) AND (tracks.carrierid = companies_carrier.id)))) LEFT JOIN users users_carrier ON (((tracks.carriertype = (2)::smallint) AND (tracks.carrierid = users_carrier.id)))) LEFT JOIN companies companies_recipient ON (((tracks.recipienttype = (1)::smallint) AND (tracks.recipientid = companies_recipient.id)))) LEFT JOIN users users_recipient ON (((tracks.recipienttype = (2)::smallint) AND (tracks.recipientid = users_recipient.id)))) LEFT JOIN containers ON ((tracks.containerid = containers.id))) LEFT JOIN trackcontrolcheckpointsview startpoint ON ((tracks.startcheckpointid = startpoint.id))) LEFT JOIN trackcontrolcheckpointsview stoppoint ON ((tracks.stopcheckpointid = stoppoint.id)));


ALTER TABLE public.tracksview OWNER TO trackit_user;

--
-- TOC entry 2916 (class 1259 OID 51812)
-- Dependencies: 3323 6
-- Name: trackvsdevice; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE trackvsdevice (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow(),
    trackid integer,
    deviceid bigint
);


ALTER TABLE public.trackvsdevice OWNER TO trackit_user;

--
-- TOC entry 1121 (class 0 OID 0)
-- Name: upc; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE upc;


--
-- TOC entry 326 (class 1255 OID 17189)
-- Dependencies: 6 1121
-- Name: isn_out(upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isn_out(upc) RETURNS cstring
    AS '$libdir/isn', 'isn_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isn_out(upc) OWNER TO postgres;

--
-- TOC entry 325 (class 1255 OID 17188)
-- Dependencies: 6 1121
-- Name: upc_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upc_in(cstring) RETURNS upc
    AS '$libdir/isn', 'upc_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.upc_in(cstring) OWNER TO postgres;

--
-- TOC entry 1120 (class 1247 OID 17187)
-- Dependencies: 6 325 326
-- Name: upc; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE upc (
    INTERNALLENGTH = 8,
    INPUT = upc_in,
    OUTPUT = public.isn_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.upc OWNER TO postgres;

--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 1120
-- Name: TYPE upc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE upc IS 'Universal Product Code (UPC)';


--
-- TOC entry 2920 (class 1259 OID 59942)
-- Dependencies: 3003 6
-- Name: usedfiles; Type: VIEW; Schema: public; Owner: trackit_user
--

CREATE VIEW usedfiles AS
    ((((((SELECT users.photoid AS fileid, 'Users$PhotoID' FROM users WHERE (users.photoid IS NOT NULL) UNION SELECT users.photolightid AS fileid, 'Users$PhotoLightID' FROM users WHERE (users.photolightid IS NOT NULL)) UNION SELECT containers.photoid AS fileid, 'Containers$PhotoID' FROM containers WHERE (containers.photoid IS NOT NULL)) UNION SELECT containers.photolightid AS fileid, 'Containers$PhotoLightID' FROM containers WHERE (containers.photolightid IS NOT NULL)) UNION SELECT location.photoid AS fileid, 'Location$PhotoID' FROM location WHERE (location.photoid IS NOT NULL)) UNION SELECT location.photolightid AS fileid, 'Location$PhotoLightID' FROM location WHERE (location.photolightid IS NOT NULL)) UNION SELECT companies.photoid AS fileid, 'Companies$PhotoID' FROM companies WHERE (companies.photoid IS NOT NULL)) UNION SELECT companies.photolightid AS fileid, 'Companies$PhotoLightID' FROM companies WHERE (companies.photolightid IS NOT NULL);


ALTER TABLE public.usedfiles OWNER TO trackit_user;

--
-- TOC entry 2918 (class 1259 OID 59921)
-- Dependencies: 3325 6
-- Name: usersenvironment; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE usersenvironment (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    key character varying(100) NOT NULL,
    value character varying(100),
    userid integer NOT NULL
);


ALTER TABLE public.usersenvironment OWNER TO trackit_user;

--
-- TOC entry 2877 (class 1259 OID 18609)
-- Dependencies: 3265 6
-- Name: uservscompany; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE uservscompany (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    userid integer NOT NULL,
    companyid integer NOT NULL
);


ALTER TABLE public.uservscompany OWNER TO trackit_user;

--
-- TOC entry 1160 (class 1247 OID 18244)
-- Dependencies: 6 2838
-- Name: var; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE var AS (
	name text,
	varclass character(1),
	linenumber integer,
	isunique boolean,
	isconst boolean,
	isnotnull boolean,
	dtype oid,
	value text
);


ALTER TYPE public.var OWNER TO postgres;

--
-- TOC entry 2847 (class 1259 OID 18339)
-- Dependencies: 3222 3223 6
-- Name: webuicontent; Type: TABLE; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE TABLE webuicontent (
    id integer NOT NULL,
    createdate timestamp without time zone DEFAULT gmtnow() NOT NULL,
    classname character varying(20) NOT NULL,
    propertyname character varying(100) NOT NULL,
    cultureid smallint NOT NULL,
    text character varying(500) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.webuicontent OWNER TO trackit_user;

--
-- TOC entry 165 (class 1255 OID 16872)
-- Dependencies: 6 1078
-- Name: cube_dim(cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_dim(cube) RETURNS integer
    AS '$libdir/cube', 'cube_dim'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_dim(cube) OWNER TO postgres;

--
-- TOC entry 164 (class 1255 OID 16871)
-- Dependencies: 1078 6 1078
-- Name: cube_distance(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_distance(cube, cube) RETURNS double precision
    AS '$libdir/cube', 'cube_distance'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_distance(cube, cube) OWNER TO postgres;

--
-- TOC entry 172 (class 1255 OID 16879)
-- Dependencies: 1078 6
-- Name: cube_is_point(cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_is_point(cube) RETURNS boolean
    AS '$libdir/cube', 'cube_is_point'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_is_point(cube) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 16963)
-- Dependencies: 6
-- Name: earth(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION earth() RETURNS double precision
    AS $$SELECT '6378168'::float8$$
    LANGUAGE sql IMMUTABLE;


ALTER FUNCTION public.earth() OWNER TO postgres;

--
-- TOC entry 1083 (class 1247 OID 16964)
-- Dependencies: 1084 1085 1086 149 1078 6
-- Name: earth; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN earth AS cube
	CONSTRAINT not_3d CHECK ((cube_dim(VALUE) <= 3))
	CONSTRAINT not_point CHECK (cube_is_point(VALUE))
	CONSTRAINT on_surface CHECK ((abs(((cube_distance(VALUE, '(0)'::cube) / earth()) - (1)::double precision)) < 9.9999999999999995e-007::double precision));


ALTER DOMAIN public.earth OWNER TO postgres;

--
-- TOC entry 1123 (class 1247 OID 17830)
-- Dependencies: 6
-- Name: lo; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN lo AS oid;


ALTER DOMAIN public.lo OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 17059)
-- Dependencies: 6
-- Name: _int_contained(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_contained(integer[], integer[]) RETURNS boolean
    AS '$libdir/_int', '_int_contained'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_contained(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 272
-- Name: FUNCTION _int_contained(integer[], integer[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION _int_contained(integer[], integer[]) IS 'contained in';


--
-- TOC entry 271 (class 1255 OID 17058)
-- Dependencies: 6
-- Name: _int_contains(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_contains(integer[], integer[]) RETURNS boolean
    AS '$libdir/_int', '_int_contains'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_contains(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 271
-- Name: FUNCTION _int_contains(integer[], integer[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION _int_contains(integer[], integer[]) IS 'contains';


--
-- TOC entry 275 (class 1255 OID 17062)
-- Dependencies: 6
-- Name: _int_different(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_different(integer[], integer[]) RETURNS boolean
    AS '$libdir/_int', '_int_different'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_different(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 3450 (class 0 OID 0)
-- Dependencies: 275
-- Name: FUNCTION _int_different(integer[], integer[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION _int_different(integer[], integer[]) IS 'different';


--
-- TOC entry 277 (class 1255 OID 17064)
-- Dependencies: 6
-- Name: _int_inter(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_inter(integer[], integer[]) RETURNS integer[]
    AS '$libdir/_int', '_int_inter'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_inter(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 17060)
-- Dependencies: 6
-- Name: _int_overlap(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_overlap(integer[], integer[]) RETURNS boolean
    AS '$libdir/_int', '_int_overlap'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_overlap(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 3451 (class 0 OID 0)
-- Dependencies: 273
-- Name: FUNCTION _int_overlap(integer[], integer[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION _int_overlap(integer[], integer[]) IS 'overlaps';


--
-- TOC entry 274 (class 1255 OID 17061)
-- Dependencies: 6
-- Name: _int_same(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_same(integer[], integer[]) RETURNS boolean
    AS '$libdir/_int', '_int_same'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_same(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 3452 (class 0 OID 0)
-- Dependencies: 274
-- Name: FUNCTION _int_same(integer[], integer[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION _int_same(integer[], integer[]) IS 'same as';


--
-- TOC entry 276 (class 1255 OID 17063)
-- Dependencies: 6
-- Name: _int_union(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _int_union(integer[], integer[]) RETURNS integer[]
    AS '$libdir/_int', '_int_union'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._int_union(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 614 (class 1255 OID 17952)
-- Dependencies: 6 1126 1129
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    AS '$libdir/ltree', '_lt_q_regex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._lt_q_regex(ltree[], lquery[]) OWNER TO postgres;

--
-- TOC entry 615 (class 1255 OID 17953)
-- Dependencies: 6 1129 1126
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    AS '$libdir/ltree', '_lt_q_rregex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._lt_q_rregex(lquery[], ltree[]) OWNER TO postgres;

--
-- TOC entry 620 (class 1255 OID 17980)
-- Dependencies: 6 1124 1126 1127
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    AS '$libdir/ltree', '_ltq_extract_regex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltq_extract_regex(ltree[], lquery) OWNER TO postgres;

--
-- TOC entry 612 (class 1255 OID 17950)
-- Dependencies: 6 1126 1127
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    AS '$libdir/ltree', '_ltq_regex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltq_regex(ltree[], lquery) OWNER TO postgres;

--
-- TOC entry 613 (class 1255 OID 17951)
-- Dependencies: 1127 6 1126
-- Name: _ltq_rregex(lquery, ltree[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltq_rregex(lquery, ltree[]) RETURNS boolean
    AS '$libdir/ltree', '_ltq_rregex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltq_rregex(lquery, ltree[]) OWNER TO postgres;

--
-- TOC entry 623 (class 1255 OID 17985)
-- Dependencies: 6
-- Name: _ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_compress(internal) RETURNS internal
    AS '$libdir/ltree', '_ltree_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public._ltree_compress(internal) OWNER TO postgres;

--
-- TOC entry 622 (class 1255 OID 17984)
-- Dependencies: 6
-- Name: _ltree_consistent(internal, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_consistent(internal, internal, smallint) RETURNS boolean
    AS '$libdir/ltree', '_ltree_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public._ltree_consistent(internal, internal, smallint) OWNER TO postgres;

--
-- TOC entry 618 (class 1255 OID 17976)
-- Dependencies: 1124 1124 1126 6
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    AS '$libdir/ltree', '_ltree_extract_isparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_extract_isparent(ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 619 (class 1255 OID 17978)
-- Dependencies: 6 1124 1126 1124
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    AS '$libdir/ltree', '_ltree_extract_risparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_extract_risparent(ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 608 (class 1255 OID 17946)
-- Dependencies: 6 1124 1126
-- Name: _ltree_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_isparent(ltree[], ltree) RETURNS boolean
    AS '$libdir/ltree', '_ltree_isparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_isparent(ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 624 (class 1255 OID 17986)
-- Dependencies: 6
-- Name: _ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/ltree', '_ltree_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 625 (class 1255 OID 17987)
-- Dependencies: 6
-- Name: _ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_picksplit(internal, internal) RETURNS internal
    AS '$libdir/ltree', '_ltree_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public._ltree_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 609 (class 1255 OID 17947)
-- Dependencies: 1124 1126 6
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    AS '$libdir/ltree', '_ltree_r_isparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_r_isparent(ltree, ltree[]) OWNER TO postgres;

--
-- TOC entry 611 (class 1255 OID 17949)
-- Dependencies: 1124 6 1126
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    AS '$libdir/ltree', '_ltree_r_risparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_r_risparent(ltree, ltree[]) OWNER TO postgres;

--
-- TOC entry 610 (class 1255 OID 17948)
-- Dependencies: 6 1126 1124
-- Name: _ltree_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_risparent(ltree[], ltree) RETURNS boolean
    AS '$libdir/ltree', '_ltree_risparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltree_risparent(ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 627 (class 1255 OID 17989)
-- Dependencies: 6
-- Name: _ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_same(internal, internal, internal) RETURNS internal
    AS '$libdir/ltree', '_ltree_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public._ltree_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 626 (class 1255 OID 17988)
-- Dependencies: 6
-- Name: _ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltree_union(internal, internal) RETURNS integer
    AS '$libdir/ltree', '_ltree_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public._ltree_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 616 (class 1255 OID 17954)
-- Dependencies: 1130 6 1126
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    AS '$libdir/ltree', '_ltxtq_exec'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltxtq_exec(ltree[], ltxtquery) OWNER TO postgres;

--
-- TOC entry 621 (class 1255 OID 17982)
-- Dependencies: 6 1124 1126 1130
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    AS '$libdir/ltree', '_ltxtq_extract_exec'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltxtq_extract_exec(ltree[], ltxtquery) OWNER TO postgres;

--
-- TOC entry 617 (class 1255 OID 17955)
-- Dependencies: 1130 6 1126
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    AS '$libdir/ltree', '_ltxtq_rexec'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public._ltxtq_rexec(ltxtquery, ltree[]) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 17006)
-- Dependencies: 6 1087
-- Name: akeys(hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION akeys(hstore) RETURNS text[]
    AS '$libdir/hstore', 'akeys'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.akeys(hstore) OWNER TO postgres;

--
-- TOC entry 684 (class 1255 OID 18096)
-- Dependencies: 6
-- Name: armor(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION armor(bytea) RETURNS text
    AS '$libdir/pgcrypto', 'pg_armor'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.armor(bytea) OWNER TO postgres;

--
-- TOC entry 718 (class 1255 OID 18174)
-- Dependencies: 6
-- Name: autoinc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION autoinc() RETURNS trigger
    AS '$libdir/autoinc', 'autoinc'
    LANGUAGE c;


ALTER FUNCTION public.autoinc() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 17007)
-- Dependencies: 1087 6
-- Name: avals(hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION avals(hstore) RETURNS text[]
    AS '$libdir/hstore', 'avals'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.avals(hstore) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 17054)
-- Dependencies: 6 1093
-- Name: boolop(integer[], query_int); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION boolop(integer[], query_int) RETURNS boolean
    AS '$libdir/_int', 'boolop'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.boolop(integer[], query_int) OWNER TO postgres;

--
-- TOC entry 3453 (class 0 OID 0)
-- Dependencies: 269
-- Name: FUNCTION boolop(integer[], query_int); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION boolop(integer[], query_int) IS 'boolean operation with array';


--
-- TOC entry 631 (class 1255 OID 18010)
-- Dependencies: 6
-- Name: bt_metap(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bt_metap(relname text, OUT magic integer, OUT version integer, OUT root integer, OUT level integer, OUT fastroot integer, OUT fastlevel integer) RETURNS record
    AS '$libdir/pageinspect', 'bt_metap'
    LANGUAGE c STRICT;


ALTER FUNCTION public.bt_metap(relname text, OUT magic integer, OUT version integer, OUT root integer, OUT level integer, OUT fastroot integer, OUT fastlevel integer) OWNER TO postgres;

--
-- TOC entry 633 (class 1255 OID 18012)
-- Dependencies: 6
-- Name: bt_page_items(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bt_page_items(relname text, blkno integer, OUT itemoffset smallint, OUT ctid tid, OUT itemlen smallint, OUT nulls boolean, OUT vars boolean, OUT data text) RETURNS SETOF record
    AS '$libdir/pageinspect', 'bt_page_items'
    LANGUAGE c STRICT;


ALTER FUNCTION public.bt_page_items(relname text, blkno integer, OUT itemoffset smallint, OUT ctid tid, OUT itemlen smallint, OUT nulls boolean, OUT vars boolean, OUT data text) OWNER TO postgres;

--
-- TOC entry 632 (class 1255 OID 18011)
-- Dependencies: 6
-- Name: bt_page_stats(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bt_page_stats(relname text, blkno integer, OUT blkno integer, OUT type "char", OUT live_items integer, OUT dead_items integer, OUT avg_item_size integer, OUT page_size integer, OUT free_size integer, OUT btpo_prev integer, OUT btpo_next integer, OUT btpo integer, OUT btpo_flags integer) RETURNS record
    AS '$libdir/pageinspect', 'bt_page_stats'
    LANGUAGE c STRICT;


ALTER FUNCTION public.bt_page_stats(relname text, blkno integer, OUT blkno integer, OUT type "char", OUT live_items integer, OUT dead_items integer, OUT avg_item_size integer, OUT page_size integer, OUT free_size integer, OUT btpo_prev integer, OUT btpo_next integer, OUT btpo integer, OUT btpo_flags integer) OWNER TO postgres;

--
-- TOC entry 495 (class 1255 OID 17529)
-- Dependencies: 1099 1099 6
-- Name: btean13cmp(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 497 (class 1255 OID 17541)
-- Dependencies: 1102 1099 6
-- Name: btean13cmp(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, isbn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 498 (class 1255 OID 17542)
-- Dependencies: 1099 1105 6
-- Name: btean13cmp(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, ismn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 499 (class 1255 OID 17543)
-- Dependencies: 1099 1108 6
-- Name: btean13cmp(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, issn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 500 (class 1255 OID 17544)
-- Dependencies: 6 1111 1099
-- Name: btean13cmp(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, isbn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 501 (class 1255 OID 17545)
-- Dependencies: 1099 1114 6
-- Name: btean13cmp(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, ismn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 502 (class 1255 OID 17546)
-- Dependencies: 1099 1117 6
-- Name: btean13cmp(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, issn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, issn) OWNER TO postgres;

--
-- TOC entry 503 (class 1255 OID 17547)
-- Dependencies: 6 1120 1099
-- Name: btean13cmp(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btean13cmp(ean13, upc) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btean13cmp(ean13, upc) OWNER TO postgres;

--
-- TOC entry 504 (class 1255 OID 17597)
-- Dependencies: 1102 6 1102
-- Name: btisbn13cmp(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btisbn13cmp(isbn13, isbn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btisbn13cmp(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 506 (class 1255 OID 17609)
-- Dependencies: 6 1102 1099
-- Name: btisbn13cmp(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btisbn13cmp(isbn13, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btisbn13cmp(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 507 (class 1255 OID 17610)
-- Dependencies: 6 1102 1111
-- Name: btisbn13cmp(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btisbn13cmp(isbn13, isbn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btisbn13cmp(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 508 (class 1255 OID 17625)
-- Dependencies: 6 1111 1111
-- Name: btisbncmp(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btisbncmp(isbn, isbn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btisbncmp(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 510 (class 1255 OID 17637)
-- Dependencies: 1111 1099 6
-- Name: btisbncmp(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btisbncmp(isbn, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btisbncmp(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 511 (class 1255 OID 17638)
-- Dependencies: 6 1111 1102
-- Name: btisbncmp(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btisbncmp(isbn, isbn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btisbncmp(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 512 (class 1255 OID 17653)
-- Dependencies: 1105 6 1105
-- Name: btismn13cmp(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btismn13cmp(ismn13, ismn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btismn13cmp(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 514 (class 1255 OID 17665)
-- Dependencies: 1099 1105 6
-- Name: btismn13cmp(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btismn13cmp(ismn13, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btismn13cmp(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 515 (class 1255 OID 17666)
-- Dependencies: 6 1114 1105
-- Name: btismn13cmp(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btismn13cmp(ismn13, ismn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btismn13cmp(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 516 (class 1255 OID 17681)
-- Dependencies: 6 1114 1114
-- Name: btismncmp(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btismncmp(ismn, ismn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btismncmp(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 518 (class 1255 OID 17693)
-- Dependencies: 6 1114 1099
-- Name: btismncmp(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btismncmp(ismn, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btismncmp(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 519 (class 1255 OID 17694)
-- Dependencies: 6 1114 1105
-- Name: btismncmp(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btismncmp(ismn, ismn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btismncmp(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 520 (class 1255 OID 17709)
-- Dependencies: 1108 1108 6
-- Name: btissn13cmp(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btissn13cmp(issn13, issn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btissn13cmp(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 522 (class 1255 OID 17721)
-- Dependencies: 6 1108 1099
-- Name: btissn13cmp(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btissn13cmp(issn13, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btissn13cmp(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 523 (class 1255 OID 17722)
-- Dependencies: 6 1108 1117
-- Name: btissn13cmp(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btissn13cmp(issn13, issn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btissn13cmp(issn13, issn) OWNER TO postgres;

--
-- TOC entry 524 (class 1255 OID 17737)
-- Dependencies: 6 1117 1117
-- Name: btissncmp(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btissncmp(issn, issn) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btissncmp(issn, issn) OWNER TO postgres;

--
-- TOC entry 526 (class 1255 OID 17749)
-- Dependencies: 1117 6 1099
-- Name: btissncmp(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btissncmp(issn, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btissncmp(issn, ean13) OWNER TO postgres;

--
-- TOC entry 527 (class 1255 OID 17750)
-- Dependencies: 1108 1117 6
-- Name: btissncmp(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btissncmp(issn, issn13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btissncmp(issn, issn13) OWNER TO postgres;

--
-- TOC entry 528 (class 1255 OID 17765)
-- Dependencies: 1120 6 1120
-- Name: btupccmp(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btupccmp(upc, upc) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btupccmp(upc, upc) OWNER TO postgres;

--
-- TOC entry 530 (class 1255 OID 17777)
-- Dependencies: 1120 6 1099
-- Name: btupccmp(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION btupccmp(upc, ean13) RETURNS integer
    AS $$btint8cmp$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.btupccmp(upc, ean13) OWNER TO postgres;

--
-- TOC entry 722 (class 1255 OID 18178)
-- Dependencies: 6
-- Name: check_foreign_key(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION check_foreign_key() RETURNS trigger
    AS '$libdir/refint', 'check_foreign_key'
    LANGUAGE c;


ALTER FUNCTION public.check_foreign_key() OWNER TO postgres;

--
-- TOC entry 721 (class 1255 OID 18177)
-- Dependencies: 6
-- Name: check_primary_key(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION check_primary_key() RETURNS trigger
    AS '$libdir/refint', 'check_primary_key'
    LANGUAGE c;


ALTER FUNCTION public.check_primary_key() OWNER TO postgres;

--
-- TOC entry 740 (class 1255 OID 18205)
-- Dependencies: 6
-- Name: connectby(text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, integer, text) RETURNS SETOF record
    AS '$libdir/tablefunc', 'connectby_text'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.connectby(text, text, text, text, integer, text) OWNER TO postgres;

--
-- TOC entry 741 (class 1255 OID 18206)
-- Dependencies: 6
-- Name: connectby(text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, integer) RETURNS SETOF record
    AS '$libdir/tablefunc', 'connectby_text'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.connectby(text, text, text, text, integer) OWNER TO postgres;

--
-- TOC entry 742 (class 1255 OID 18207)
-- Dependencies: 6
-- Name: connectby(text, text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, text, integer, text) RETURNS SETOF record
    AS '$libdir/tablefunc', 'connectby_text_serial'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.connectby(text, text, text, text, text, integer, text) OWNER TO postgres;

--
-- TOC entry 743 (class 1255 OID 18208)
-- Dependencies: 6
-- Name: connectby(text, text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION connectby(text, text, text, text, text, integer) RETURNS SETOF record
    AS '$libdir/tablefunc', 'connectby_text_serial'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.connectby(text, text, text, text, text, integer) OWNER TO postgres;

--
-- TOC entry 734 (class 1255 OID 18190)
-- Dependencies: 6
-- Name: crosstab(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab(text) RETURNS SETOF record
    AS '$libdir/tablefunc', 'crosstab'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.crosstab(text) OWNER TO postgres;

--
-- TOC entry 738 (class 1255 OID 18203)
-- Dependencies: 6
-- Name: crosstab(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab(text, integer) RETURNS SETOF record
    AS '$libdir/tablefunc', 'crosstab'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.crosstab(text, integer) OWNER TO postgres;

--
-- TOC entry 739 (class 1255 OID 18204)
-- Dependencies: 6
-- Name: crosstab(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab(text, text) RETURNS SETOF record
    AS '$libdir/tablefunc', 'crosstab_hash'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.crosstab(text, text) OWNER TO postgres;

--
-- TOC entry 735 (class 1255 OID 18200)
-- Dependencies: 1148 6
-- Name: crosstab2(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab2(text) RETURNS SETOF tablefunc_crosstab_2
    AS '$libdir/tablefunc', 'crosstab'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.crosstab2(text) OWNER TO postgres;

--
-- TOC entry 736 (class 1255 OID 18201)
-- Dependencies: 6 1150
-- Name: crosstab3(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab3(text) RETURNS SETOF tablefunc_crosstab_3
    AS '$libdir/tablefunc', 'crosstab'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.crosstab3(text) OWNER TO postgres;

--
-- TOC entry 737 (class 1255 OID 18202)
-- Dependencies: 6 1152
-- Name: crosstab4(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosstab4(text) RETURNS SETOF tablefunc_crosstab_4
    AS '$libdir/tablefunc', 'crosstab'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.crosstab4(text) OWNER TO postgres;

--
-- TOC entry 657 (class 1255 OID 18069)
-- Dependencies: 6
-- Name: crypt(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crypt(text, text) RETURNS text
    AS '$libdir/pgcrypto', 'pg_crypt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.crypt(text, text) OWNER TO postgres;

--
-- TOC entry 147 (class 1255 OID 16853)
-- Dependencies: 6 1078
-- Name: cube(double precision[], double precision[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube(double precision[], double precision[]) RETURNS cube
    AS '$libdir/cube', 'cube_a_f8_f8'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube(double precision[], double precision[]) OWNER TO postgres;

--
-- TOC entry 148 (class 1255 OID 16854)
-- Dependencies: 1078 6
-- Name: cube(double precision[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube(double precision[]) RETURNS cube
    AS '$libdir/cube', 'cube_a_f8'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube(double precision[]) OWNER TO postgres;

--
-- TOC entry 168 (class 1255 OID 16875)
-- Dependencies: 6 1078
-- Name: cube(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube(double precision) RETURNS cube
    AS '$libdir/cube', 'cube_f8'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube(double precision) OWNER TO postgres;

--
-- TOC entry 169 (class 1255 OID 16876)
-- Dependencies: 6 1078
-- Name: cube(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube(double precision, double precision) RETURNS cube
    AS '$libdir/cube', 'cube_f8_f8'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube(double precision, double precision) OWNER TO postgres;

--
-- TOC entry 170 (class 1255 OID 16877)
-- Dependencies: 6 1078 1078
-- Name: cube(cube, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube(cube, double precision) RETURNS cube
    AS '$libdir/cube', 'cube_c_f8'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube(cube, double precision) OWNER TO postgres;

--
-- TOC entry 171 (class 1255 OID 16878)
-- Dependencies: 1078 1078 6
-- Name: cube(cube, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube(cube, double precision, double precision) RETURNS cube
    AS '$libdir/cube', 'cube_c_f8_f8'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube(cube, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 156 (class 1255 OID 16863)
-- Dependencies: 1078 6 1078
-- Name: cube_cmp(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_cmp(cube, cube) RETURNS integer
    AS '$libdir/cube', 'cube_cmp'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_cmp(cube, cube) OWNER TO postgres;

--
-- TOC entry 3454 (class 0 OID 0)
-- Dependencies: 156
-- Name: FUNCTION cube_cmp(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_cmp(cube, cube) IS 'btree comparison function';


--
-- TOC entry 158 (class 1255 OID 16865)
-- Dependencies: 1078 6 1078
-- Name: cube_contained(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_contained(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_contained'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_contained(cube, cube) OWNER TO postgres;

--
-- TOC entry 3455 (class 0 OID 0)
-- Dependencies: 158
-- Name: FUNCTION cube_contained(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_contained(cube, cube) IS 'contained in';


--
-- TOC entry 157 (class 1255 OID 16864)
-- Dependencies: 1078 6 1078
-- Name: cube_contains(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_contains(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_contains'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_contains(cube, cube) OWNER TO postgres;

--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 157
-- Name: FUNCTION cube_contains(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_contains(cube, cube) IS 'contains';


--
-- TOC entry 173 (class 1255 OID 16880)
-- Dependencies: 6 1078 1078
-- Name: cube_enlarge(cube, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_enlarge(cube, double precision, integer) RETURNS cube
    AS '$libdir/cube', 'cube_enlarge'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_enlarge(cube, double precision, integer) OWNER TO postgres;

--
-- TOC entry 150 (class 1255 OID 16857)
-- Dependencies: 1078 6 1078
-- Name: cube_eq(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_eq(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_eq'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_eq(cube, cube) OWNER TO postgres;

--
-- TOC entry 3457 (class 0 OID 0)
-- Dependencies: 150
-- Name: FUNCTION cube_eq(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_eq(cube, cube) IS 'same as';


--
-- TOC entry 155 (class 1255 OID 16862)
-- Dependencies: 1078 6 1078
-- Name: cube_ge(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_ge(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_ge'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_ge(cube, cube) OWNER TO postgres;

--
-- TOC entry 3458 (class 0 OID 0)
-- Dependencies: 155
-- Name: FUNCTION cube_ge(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_ge(cube, cube) IS 'greater than or equal to';


--
-- TOC entry 153 (class 1255 OID 16860)
-- Dependencies: 1078 6 1078
-- Name: cube_gt(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_gt(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_gt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_gt(cube, cube) OWNER TO postgres;

--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 153
-- Name: FUNCTION cube_gt(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_gt(cube, cube) IS 'greater than';


--
-- TOC entry 161 (class 1255 OID 16868)
-- Dependencies: 1078 6 1078 1078
-- Name: cube_inter(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_inter(cube, cube) RETURNS cube
    AS '$libdir/cube', 'cube_inter'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_inter(cube, cube) OWNER TO postgres;

--
-- TOC entry 154 (class 1255 OID 16861)
-- Dependencies: 1078 6 1078
-- Name: cube_le(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_le(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_le'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_le(cube, cube) OWNER TO postgres;

--
-- TOC entry 3460 (class 0 OID 0)
-- Dependencies: 154
-- Name: FUNCTION cube_le(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_le(cube, cube) IS 'lower than or equal to';


--
-- TOC entry 166 (class 1255 OID 16873)
-- Dependencies: 6 1078
-- Name: cube_ll_coord(cube, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_ll_coord(cube, integer) RETURNS double precision
    AS '$libdir/cube', 'cube_ll_coord'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_ll_coord(cube, integer) OWNER TO postgres;

--
-- TOC entry 152 (class 1255 OID 16859)
-- Dependencies: 1078 6 1078
-- Name: cube_lt(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_lt(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_lt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_lt(cube, cube) OWNER TO postgres;

--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 152
-- Name: FUNCTION cube_lt(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_lt(cube, cube) IS 'lower than';


--
-- TOC entry 151 (class 1255 OID 16858)
-- Dependencies: 1078 6 1078
-- Name: cube_ne(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_ne(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_ne'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_ne(cube, cube) OWNER TO postgres;

--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 151
-- Name: FUNCTION cube_ne(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_ne(cube, cube) IS 'different';


--
-- TOC entry 159 (class 1255 OID 16866)
-- Dependencies: 6 1078 1078
-- Name: cube_overlap(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_overlap(cube, cube) RETURNS boolean
    AS '$libdir/cube', 'cube_overlap'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_overlap(cube, cube) OWNER TO postgres;

--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 159
-- Name: FUNCTION cube_overlap(cube, cube); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION cube_overlap(cube, cube) IS 'overlaps';


--
-- TOC entry 162 (class 1255 OID 16869)
-- Dependencies: 6 1078
-- Name: cube_size(cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_size(cube) RETURNS double precision
    AS '$libdir/cube', 'cube_size'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_size(cube) OWNER TO postgres;

--
-- TOC entry 163 (class 1255 OID 16870)
-- Dependencies: 1078 6 1078
-- Name: cube_subset(cube, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_subset(cube, integer[]) RETURNS cube
    AS '$libdir/cube', 'cube_subset'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_subset(cube, integer[]) OWNER TO postgres;

--
-- TOC entry 160 (class 1255 OID 16867)
-- Dependencies: 1078 6 1078 1078
-- Name: cube_union(cube, cube); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_union(cube, cube) RETURNS cube
    AS '$libdir/cube', 'cube_union'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_union(cube, cube) OWNER TO postgres;

--
-- TOC entry 167 (class 1255 OID 16874)
-- Dependencies: 6 1078
-- Name: cube_ur_coord(cube, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cube_ur_coord(cube, integer) RETURNS double precision
    AS '$libdir/cube', 'cube_ur_coord'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.cube_ur_coord(cube, integer) OWNER TO postgres;

--
-- TOC entry 197 (class 1255 OID 16940)
-- Dependencies: 6
-- Name: dblink(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text, text) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink(text, text) OWNER TO postgres;

--
-- TOC entry 198 (class 1255 OID 16941)
-- Dependencies: 6
-- Name: dblink(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text, text, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink(text, text, boolean) OWNER TO postgres;

--
-- TOC entry 199 (class 1255 OID 16942)
-- Dependencies: 6
-- Name: dblink(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink(text) OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 16943)
-- Dependencies: 6
-- Name: dblink(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink(text, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink(text, boolean) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 16953)
-- Dependencies: 6
-- Name: dblink_build_sql_delete(text, int2vector, integer, text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_build_sql_delete(text, int2vector, integer, text[]) RETURNS text
    AS '$libdir/dblink', 'dblink_build_sql_delete'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_build_sql_delete(text, int2vector, integer, text[]) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 16952)
-- Dependencies: 6
-- Name: dblink_build_sql_insert(text, int2vector, integer, text[], text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_build_sql_insert(text, int2vector, integer, text[], text[]) RETURNS text
    AS '$libdir/dblink', 'dblink_build_sql_insert'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_build_sql_insert(text, int2vector, integer, text[], text[]) OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 16954)
-- Dependencies: 6
-- Name: dblink_build_sql_update(text, int2vector, integer, text[], text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_build_sql_update(text, int2vector, integer, text[], text[]) RETURNS text
    AS '$libdir/dblink', 'dblink_build_sql_update'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_build_sql_update(text, int2vector, integer, text[], text[]) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 16961)
-- Dependencies: 6
-- Name: dblink_cancel_query(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_cancel_query(text) RETURNS text
    AS '$libdir/dblink', 'dblink_cancel_query'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_cancel_query(text) OWNER TO postgres;

--
-- TOC entry 193 (class 1255 OID 16936)
-- Dependencies: 6
-- Name: dblink_close(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_close(text) OWNER TO postgres;

--
-- TOC entry 194 (class 1255 OID 16937)
-- Dependencies: 6
-- Name: dblink_close(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_close(text, boolean) OWNER TO postgres;

--
-- TOC entry 195 (class 1255 OID 16938)
-- Dependencies: 6
-- Name: dblink_close(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_close(text, text) OWNER TO postgres;

--
-- TOC entry 196 (class 1255 OID 16939)
-- Dependencies: 6
-- Name: dblink_close(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_close(text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_close(text, text, boolean) OWNER TO postgres;

--
-- TOC entry 181 (class 1255 OID 16922)
-- Dependencies: 6
-- Name: dblink_connect(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect(text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_connect(text) OWNER TO postgres;

--
-- TOC entry 182 (class 1255 OID 16923)
-- Dependencies: 6
-- Name: dblink_connect(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_connect(text, text) OWNER TO postgres;

--
-- TOC entry 789 (class 1255 OID 16924)
-- Dependencies: 6
-- Name: dblink_connect_u(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect_u(text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT SECURITY DEFINER;


ALTER FUNCTION public.dblink_connect_u(text) OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 16925)
-- Dependencies: 6
-- Name: dblink_connect_u(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_connect_u(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT SECURITY DEFINER;


ALTER FUNCTION public.dblink_connect_u(text, text) OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 16955)
-- Dependencies: 6
-- Name: dblink_current_query(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_current_query() RETURNS text
    AS '$libdir/dblink', 'dblink_current_query'
    LANGUAGE c;


ALTER FUNCTION public.dblink_current_query() OWNER TO postgres;

--
-- TOC entry 183 (class 1255 OID 16926)
-- Dependencies: 6
-- Name: dblink_disconnect(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_disconnect() RETURNS text
    AS '$libdir/dblink', 'dblink_disconnect'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_disconnect() OWNER TO postgres;

--
-- TOC entry 184 (class 1255 OID 16927)
-- Dependencies: 6
-- Name: dblink_disconnect(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_disconnect(text) RETURNS text
    AS '$libdir/dblink', 'dblink_disconnect'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_disconnect(text) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 16962)
-- Dependencies: 6
-- Name: dblink_error_message(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_error_message(text) RETURNS text
    AS '$libdir/dblink', 'dblink_error_message'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_error_message(text) OWNER TO postgres;

--
-- TOC entry 201 (class 1255 OID 16944)
-- Dependencies: 6
-- Name: dblink_exec(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_exec(text, text) OWNER TO postgres;

--
-- TOC entry 202 (class 1255 OID 16945)
-- Dependencies: 6
-- Name: dblink_exec(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_exec(text, text, boolean) OWNER TO postgres;

--
-- TOC entry 203 (class 1255 OID 16946)
-- Dependencies: 6
-- Name: dblink_exec(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_exec(text) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 16947)
-- Dependencies: 6
-- Name: dblink_exec(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_exec(text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_exec(text, boolean) OWNER TO postgres;

--
-- TOC entry 189 (class 1255 OID 16932)
-- Dependencies: 6
-- Name: dblink_fetch(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, integer) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_fetch(text, integer) OWNER TO postgres;

--
-- TOC entry 190 (class 1255 OID 16933)
-- Dependencies: 6
-- Name: dblink_fetch(text, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, integer, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_fetch(text, integer, boolean) OWNER TO postgres;

--
-- TOC entry 191 (class 1255 OID 16934)
-- Dependencies: 6
-- Name: dblink_fetch(text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, text, integer) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_fetch(text, text, integer) OWNER TO postgres;

--
-- TOC entry 192 (class 1255 OID 16935)
-- Dependencies: 6
-- Name: dblink_fetch(text, text, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_fetch(text, text, integer, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_fetch(text, text, integer, boolean) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 16960)
-- Dependencies: 6
-- Name: dblink_get_connections(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_connections() RETURNS text[]
    AS '$libdir/dblink', 'dblink_get_connections'
    LANGUAGE c;


ALTER FUNCTION public.dblink_get_connections() OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 16951)
-- Dependencies: 6 1081
-- Name: dblink_get_pkey(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_pkey(text) RETURNS SETOF dblink_pkey_results
    AS '$libdir/dblink', 'dblink_get_pkey'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_get_pkey(text) OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 16958)
-- Dependencies: 6
-- Name: dblink_get_result(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_result(text) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_get_result'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_get_result(text) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 16959)
-- Dependencies: 6
-- Name: dblink_get_result(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_get_result(text, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_get_result'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_get_result(text, boolean) OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 16957)
-- Dependencies: 6
-- Name: dblink_is_busy(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_is_busy(text) RETURNS integer
    AS '$libdir/dblink', 'dblink_is_busy'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_is_busy(text) OWNER TO postgres;

--
-- TOC entry 185 (class 1255 OID 16928)
-- Dependencies: 6
-- Name: dblink_open(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_open(text, text) OWNER TO postgres;

--
-- TOC entry 186 (class 1255 OID 16929)
-- Dependencies: 6
-- Name: dblink_open(text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_open(text, text, boolean) OWNER TO postgres;

--
-- TOC entry 187 (class 1255 OID 16930)
-- Dependencies: 6
-- Name: dblink_open(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_open(text, text, text) OWNER TO postgres;

--
-- TOC entry 188 (class 1255 OID 16931)
-- Dependencies: 6
-- Name: dblink_open(text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_open(text, text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_open(text, text, text, boolean) OWNER TO postgres;

--
-- TOC entry 210 (class 1255 OID 16956)
-- Dependencies: 6
-- Name: dblink_send_query(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dblink_send_query(text, text) RETURNS integer
    AS '$libdir/dblink', 'dblink_send_query'
    LANGUAGE c STRICT;


ALTER FUNCTION public.dblink_send_query(text, text) OWNER TO postgres;

--
-- TOC entry 685 (class 1255 OID 18097)
-- Dependencies: 6
-- Name: dearmor(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dearmor(text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_dearmor'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.dearmor(text) OWNER TO postgres;

--
-- TOC entry 661 (class 1255 OID 18073)
-- Dependencies: 6
-- Name: decrypt(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION decrypt(bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_decrypt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.decrypt(bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 663 (class 1255 OID 18075)
-- Dependencies: 6
-- Name: decrypt_iv(bytea, bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION decrypt_iv(bytea, bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_decrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 16994)
-- Dependencies: 6 1087
-- Name: defined(hstore, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION defined(hstore, text) RETURNS boolean
    AS '$libdir/hstore', 'defined'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.defined(hstore, text) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 16995)
-- Dependencies: 1087 6 1087
-- Name: delete(hstore, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete(hstore, text) RETURNS hstore
    AS '$libdir/hstore', 'delete'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.delete(hstore, text) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16981)
-- Dependencies: 6
-- Name: difference(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION difference(text, text) RETURNS integer
    AS '$libdir/fuzzystrmatch', 'difference'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.difference(text, text) OWNER TO postgres;

--
-- TOC entry 653 (class 1255 OID 18065)
-- Dependencies: 6
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.digest(text, text) OWNER TO postgres;

--
-- TOC entry 654 (class 1255 OID 18066)
-- Dependencies: 6
-- Name: digest(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION digest(bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.digest(bytea, text) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16982)
-- Dependencies: 6
-- Name: dmetaphone(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dmetaphone(text) RETURNS text
    AS '$libdir/fuzzystrmatch', 'dmetaphone'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.dmetaphone(text) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 16983)
-- Dependencies: 6
-- Name: dmetaphone_alt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dmetaphone_alt(text) RETURNS text
    AS '$libdir/fuzzystrmatch', 'dmetaphone_alt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.dmetaphone_alt(text) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 17010)
-- Dependencies: 6 1087
-- Name: each(hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION each(hs hstore, OUT key text, OUT value text) RETURNS SETOF record
    AS '$libdir/hstore', 'each'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.each(hs hstore, OUT key text, OUT value text) OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 16974)
-- Dependencies: 1083 1078 6
-- Name: earth_box(earth, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION earth_box(earth, double precision) RETURNS cube
    AS $_$SELECT cube_enlarge($1, gc_to_sec($2), 3)$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.earth_box(earth, double precision) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 16973)
-- Dependencies: 1083 6 1083
-- Name: earth_distance(earth, earth); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION earth_distance(earth, earth) RETURNS double precision
    AS $_$SELECT sec_to_gc(cube_distance($1, $2))$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.earth_distance(earth, earth) OWNER TO postgres;

--
-- TOC entry 660 (class 1255 OID 18072)
-- Dependencies: 6
-- Name: encrypt(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION encrypt(bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_encrypt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.encrypt(bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 662 (class 1255 OID 18074)
-- Dependencies: 6
-- Name: encrypt_iv(bytea, bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION encrypt_iv(bytea, bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_encrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 144 (class 1255 OID 16847)
-- Dependencies: 6 1075
-- Name: eq(chkpass, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION eq(chkpass, text) RETURNS boolean
    AS '$libdir/chkpass', 'chkpass_eq'
    LANGUAGE c STRICT;


ALTER FUNCTION public.eq(chkpass, text) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16991)
-- Dependencies: 1087 6
-- Name: exist(hstore, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION exist(hstore, text) RETURNS boolean
    AS '$libdir/hstore', 'exists'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.exist(hstore, text) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 16988)
-- Dependencies: 6 1087
-- Name: fetchval(hstore, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fetchval(hstore, text) RETURNS text
    AS '$libdir/hstore', 'fetchval'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.fetchval(hstore, text) OWNER TO postgres;

--
-- TOC entry 175 (class 1255 OID 16893)
-- Dependencies: 6
-- Name: g_cube_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_compress(internal) RETURNS internal
    AS '$libdir/cube', 'g_cube_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_cube_compress(internal) OWNER TO postgres;

--
-- TOC entry 174 (class 1255 OID 16892)
-- Dependencies: 6 1078
-- Name: g_cube_consistent(internal, cube, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_consistent(internal, cube, integer) RETURNS boolean
    AS '$libdir/cube', 'g_cube_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_cube_consistent(internal, cube, integer) OWNER TO postgres;

--
-- TOC entry 176 (class 1255 OID 16894)
-- Dependencies: 6
-- Name: g_cube_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_decompress(internal) RETURNS internal
    AS '$libdir/cube', 'g_cube_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_cube_decompress(internal) OWNER TO postgres;

--
-- TOC entry 177 (class 1255 OID 16895)
-- Dependencies: 6
-- Name: g_cube_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/cube', 'g_cube_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.g_cube_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 178 (class 1255 OID 16896)
-- Dependencies: 6
-- Name: g_cube_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_picksplit(internal, internal) RETURNS internal
    AS '$libdir/cube', 'g_cube_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_cube_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 180 (class 1255 OID 16898)
-- Dependencies: 1078 6 1078
-- Name: g_cube_same(cube, cube, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_same(cube, cube, internal) RETURNS internal
    AS '$libdir/cube', 'g_cube_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_cube_same(cube, cube, internal) OWNER TO postgres;

--
-- TOC entry 179 (class 1255 OID 16897)
-- Dependencies: 6 1078
-- Name: g_cube_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_cube_union(internal, internal) RETURNS cube
    AS '$libdir/cube', 'g_cube_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_cube_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 17095)
-- Dependencies: 6
-- Name: g_int_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_compress(internal) RETURNS internal
    AS '$libdir/_int', 'g_int_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_int_compress(internal) OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 17094)
-- Dependencies: 6
-- Name: g_int_consistent(internal, integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_consistent(internal, integer[], integer) RETURNS boolean
    AS '$libdir/_int', 'g_int_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_int_consistent(internal, integer[], integer) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 17096)
-- Dependencies: 6
-- Name: g_int_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_decompress(internal) RETURNS internal
    AS '$libdir/_int', 'g_int_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_int_decompress(internal) OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 17097)
-- Dependencies: 6
-- Name: g_int_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/_int', 'g_int_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.g_int_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 17098)
-- Dependencies: 6
-- Name: g_int_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_picksplit(internal, internal) RETURNS internal
    AS '$libdir/_int', 'g_int_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_int_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 17100)
-- Dependencies: 6
-- Name: g_int_same(integer[], integer[], internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_same(integer[], integer[], internal) RETURNS internal
    AS '$libdir/_int', 'g_int_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_int_same(integer[], integer[], internal) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 17099)
-- Dependencies: 6
-- Name: g_int_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_int_union(internal, internal) RETURNS integer[]
    AS '$libdir/_int', 'g_int_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_int_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 17122)
-- Dependencies: 6
-- Name: g_intbig_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_compress(internal) RETURNS internal
    AS '$libdir/_int', 'g_intbig_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_intbig_compress(internal) OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 17121)
-- Dependencies: 6
-- Name: g_intbig_consistent(internal, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_consistent(internal, internal, integer) RETURNS boolean
    AS '$libdir/_int', 'g_intbig_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_intbig_consistent(internal, internal, integer) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 17123)
-- Dependencies: 6
-- Name: g_intbig_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_decompress(internal) RETURNS internal
    AS '$libdir/_int', 'g_intbig_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_intbig_decompress(internal) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 17124)
-- Dependencies: 6
-- Name: g_intbig_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/_int', 'g_intbig_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.g_intbig_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 17125)
-- Dependencies: 6
-- Name: g_intbig_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_picksplit(internal, internal) RETURNS internal
    AS '$libdir/_int', 'g_intbig_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_intbig_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 17127)
-- Dependencies: 6
-- Name: g_intbig_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_same(internal, internal, internal) RETURNS internal
    AS '$libdir/_int', 'g_intbig_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_intbig_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 17126)
-- Dependencies: 6
-- Name: g_intbig_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION g_intbig_union(internal, internal) RETURNS integer[]
    AS '$libdir/_int', 'g_intbig_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.g_intbig_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 130 (class 1255 OID 16775)
-- Dependencies: 6
-- Name: gbt_bit_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bit_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bit_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bit_compress(internal) OWNER TO postgres;

--
-- TOC entry 129 (class 1255 OID 16774)
-- Dependencies: 6
-- Name: gbt_bit_consistent(internal, bit, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bit_consistent(internal, bit, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_bit_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bit_consistent(internal, bit, smallint) OWNER TO postgres;

--
-- TOC entry 131 (class 1255 OID 16776)
-- Dependencies: 6
-- Name: gbt_bit_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bit_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bit_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_bit_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 132 (class 1255 OID 16777)
-- Dependencies: 6
-- Name: gbt_bit_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bit_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bit_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bit_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 134 (class 1255 OID 16779)
-- Dependencies: 6
-- Name: gbt_bit_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bit_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bit_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bit_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 133 (class 1255 OID 16778)
-- Dependencies: 1072 6
-- Name: gbt_bit_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bit_union(bytea, internal) RETURNS gbtreekey_var
    AS '$libdir/btree_gist', 'gbt_bit_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bit_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 112 (class 1255 OID 16701)
-- Dependencies: 6
-- Name: gbt_bpchar_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bpchar_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bpchar_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bpchar_compress(internal) OWNER TO postgres;

--
-- TOC entry 110 (class 1255 OID 16699)
-- Dependencies: 6
-- Name: gbt_bpchar_consistent(internal, character, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bpchar_consistent(internal, character, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_bpchar_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bpchar_consistent(internal, character, smallint) OWNER TO postgres;

--
-- TOC entry 118 (class 1255 OID 16735)
-- Dependencies: 6
-- Name: gbt_bytea_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bytea_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bytea_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bytea_compress(internal) OWNER TO postgres;

--
-- TOC entry 117 (class 1255 OID 16734)
-- Dependencies: 6
-- Name: gbt_bytea_consistent(internal, bytea, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bytea_consistent(internal, bytea, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_bytea_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bytea_consistent(internal, bytea, smallint) OWNER TO postgres;

--
-- TOC entry 119 (class 1255 OID 16736)
-- Dependencies: 6
-- Name: gbt_bytea_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bytea_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bytea_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_bytea_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 120 (class 1255 OID 16737)
-- Dependencies: 6
-- Name: gbt_bytea_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bytea_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bytea_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bytea_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 122 (class 1255 OID 16739)
-- Dependencies: 6
-- Name: gbt_bytea_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bytea_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_bytea_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bytea_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 121 (class 1255 OID 16738)
-- Dependencies: 6 1072
-- Name: gbt_bytea_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_bytea_union(bytea, internal) RETURNS gbtreekey_var
    AS '$libdir/btree_gist', 'gbt_bytea_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_bytea_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 98 (class 1255 OID 16659)
-- Dependencies: 6
-- Name: gbt_cash_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_cash_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_cash_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_cash_compress(internal) OWNER TO postgres;

--
-- TOC entry 97 (class 1255 OID 16658)
-- Dependencies: 6
-- Name: gbt_cash_consistent(internal, money, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_cash_consistent(internal, money, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_cash_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_cash_consistent(internal, money, smallint) OWNER TO postgres;

--
-- TOC entry 99 (class 1255 OID 16660)
-- Dependencies: 6
-- Name: gbt_cash_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_cash_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_cash_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_cash_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 100 (class 1255 OID 16661)
-- Dependencies: 6
-- Name: gbt_cash_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_cash_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_cash_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_cash_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 102 (class 1255 OID 16663)
-- Dependencies: 6
-- Name: gbt_cash_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_cash_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_cash_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_cash_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 101 (class 1255 OID 16662)
-- Dependencies: 1063 6
-- Name: gbt_cash_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_cash_union(bytea, internal) RETURNS gbtreekey8
    AS '$libdir/btree_gist', 'gbt_cash_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_cash_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 85 (class 1255 OID 16618)
-- Dependencies: 6
-- Name: gbt_date_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_date_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_date_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_date_compress(internal) OWNER TO postgres;

--
-- TOC entry 84 (class 1255 OID 16617)
-- Dependencies: 6
-- Name: gbt_date_consistent(internal, date, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_date_consistent(internal, date, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_date_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_date_consistent(internal, date, smallint) OWNER TO postgres;

--
-- TOC entry 86 (class 1255 OID 16619)
-- Dependencies: 6
-- Name: gbt_date_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_date_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_date_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_date_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 87 (class 1255 OID 16620)
-- Dependencies: 6
-- Name: gbt_date_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_date_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_date_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_date_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 89 (class 1255 OID 16622)
-- Dependencies: 6
-- Name: gbt_date_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_date_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_date_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_date_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 88 (class 1255 OID 16621)
-- Dependencies: 6 1063
-- Name: gbt_date_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_date_union(bytea, internal) RETURNS gbtreekey8
    AS '$libdir/btree_gist', 'gbt_date_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_date_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 32 (class 1255 OID 16425)
-- Dependencies: 6
-- Name: gbt_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_decompress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_decompress(internal) OWNER TO postgres;

--
-- TOC entry 57 (class 1255 OID 16506)
-- Dependencies: 6
-- Name: gbt_float4_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float4_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float4_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float4_compress(internal) OWNER TO postgres;

--
-- TOC entry 56 (class 1255 OID 16505)
-- Dependencies: 6
-- Name: gbt_float4_consistent(internal, real, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float4_consistent(internal, real, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_float4_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float4_consistent(internal, real, smallint) OWNER TO postgres;

--
-- TOC entry 58 (class 1255 OID 16507)
-- Dependencies: 6
-- Name: gbt_float4_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float4_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float4_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_float4_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 59 (class 1255 OID 16508)
-- Dependencies: 6
-- Name: gbt_float4_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float4_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float4_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float4_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 61 (class 1255 OID 16510)
-- Dependencies: 6
-- Name: gbt_float4_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float4_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float4_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float4_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 60 (class 1255 OID 16509)
-- Dependencies: 1063 6
-- Name: gbt_float4_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float4_union(bytea, internal) RETURNS gbtreekey8
    AS '$libdir/btree_gist', 'gbt_float4_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float4_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 63 (class 1255 OID 16526)
-- Dependencies: 6
-- Name: gbt_float8_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float8_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float8_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float8_compress(internal) OWNER TO postgres;

--
-- TOC entry 62 (class 1255 OID 16525)
-- Dependencies: 6
-- Name: gbt_float8_consistent(internal, double precision, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float8_consistent(internal, double precision, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_float8_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float8_consistent(internal, double precision, smallint) OWNER TO postgres;

--
-- TOC entry 64 (class 1255 OID 16527)
-- Dependencies: 6
-- Name: gbt_float8_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float8_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float8_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_float8_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 65 (class 1255 OID 16528)
-- Dependencies: 6
-- Name: gbt_float8_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float8_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float8_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float8_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 67 (class 1255 OID 16530)
-- Dependencies: 6
-- Name: gbt_float8_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float8_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_float8_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float8_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 66 (class 1255 OID 16529)
-- Dependencies: 1066 6
-- Name: gbt_float8_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_float8_union(bytea, internal) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbt_float8_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_float8_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 136 (class 1255 OID 16809)
-- Dependencies: 6
-- Name: gbt_inet_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_inet_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_inet_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_inet_compress(internal) OWNER TO postgres;

--
-- TOC entry 135 (class 1255 OID 16808)
-- Dependencies: 6
-- Name: gbt_inet_consistent(internal, inet, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_inet_consistent(internal, inet, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_inet_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_inet_consistent(internal, inet, smallint) OWNER TO postgres;

--
-- TOC entry 137 (class 1255 OID 16810)
-- Dependencies: 6
-- Name: gbt_inet_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_inet_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_inet_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_inet_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 138 (class 1255 OID 16811)
-- Dependencies: 6
-- Name: gbt_inet_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_inet_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_inet_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_inet_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 140 (class 1255 OID 16813)
-- Dependencies: 6
-- Name: gbt_inet_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_inet_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_inet_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_inet_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 139 (class 1255 OID 16812)
-- Dependencies: 1066 6
-- Name: gbt_inet_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_inet_union(bytea, internal) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbt_inet_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_inet_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 39 (class 1255 OID 16446)
-- Dependencies: 6
-- Name: gbt_int2_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int2_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int2_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int2_compress(internal) OWNER TO postgres;

--
-- TOC entry 38 (class 1255 OID 16445)
-- Dependencies: 6
-- Name: gbt_int2_consistent(internal, smallint, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int2_consistent(internal, smallint, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_int2_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int2_consistent(internal, smallint, smallint) OWNER TO postgres;

--
-- TOC entry 40 (class 1255 OID 16447)
-- Dependencies: 6
-- Name: gbt_int2_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int2_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int2_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_int2_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 41 (class 1255 OID 16448)
-- Dependencies: 6
-- Name: gbt_int2_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int2_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int2_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int2_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 43 (class 1255 OID 16450)
-- Dependencies: 6
-- Name: gbt_int2_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int2_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int2_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int2_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 42 (class 1255 OID 16449)
-- Dependencies: 1024 6
-- Name: gbt_int2_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int2_union(bytea, internal) RETURNS gbtreekey4
    AS '$libdir/btree_gist', 'gbt_int2_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int2_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 45 (class 1255 OID 16466)
-- Dependencies: 6
-- Name: gbt_int4_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int4_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int4_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int4_compress(internal) OWNER TO postgres;

--
-- TOC entry 44 (class 1255 OID 16465)
-- Dependencies: 6
-- Name: gbt_int4_consistent(internal, integer, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int4_consistent(internal, integer, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_int4_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int4_consistent(internal, integer, smallint) OWNER TO postgres;

--
-- TOC entry 46 (class 1255 OID 16467)
-- Dependencies: 6
-- Name: gbt_int4_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int4_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int4_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_int4_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 47 (class 1255 OID 16468)
-- Dependencies: 6
-- Name: gbt_int4_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int4_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int4_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int4_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 49 (class 1255 OID 16470)
-- Dependencies: 6
-- Name: gbt_int4_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int4_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int4_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int4_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 48 (class 1255 OID 16469)
-- Dependencies: 1063 6
-- Name: gbt_int4_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int4_union(bytea, internal) RETURNS gbtreekey8
    AS '$libdir/btree_gist', 'gbt_int4_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int4_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 51 (class 1255 OID 16486)
-- Dependencies: 6
-- Name: gbt_int8_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int8_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int8_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int8_compress(internal) OWNER TO postgres;

--
-- TOC entry 50 (class 1255 OID 16485)
-- Dependencies: 6
-- Name: gbt_int8_consistent(internal, bigint, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int8_consistent(internal, bigint, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_int8_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int8_consistent(internal, bigint, smallint) OWNER TO postgres;

--
-- TOC entry 52 (class 1255 OID 16487)
-- Dependencies: 6
-- Name: gbt_int8_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int8_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int8_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_int8_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 53 (class 1255 OID 16488)
-- Dependencies: 6
-- Name: gbt_int8_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int8_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int8_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int8_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 55 (class 1255 OID 16490)
-- Dependencies: 6
-- Name: gbt_int8_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int8_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_int8_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int8_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 54 (class 1255 OID 16489)
-- Dependencies: 1066 6
-- Name: gbt_int8_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_int8_union(bytea, internal) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbt_int8_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_int8_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 91 (class 1255 OID 16638)
-- Dependencies: 6
-- Name: gbt_intv_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_intv_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_intv_compress(internal) OWNER TO postgres;

--
-- TOC entry 90 (class 1255 OID 16637)
-- Dependencies: 6
-- Name: gbt_intv_consistent(internal, interval, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_consistent(internal, interval, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_intv_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_intv_consistent(internal, interval, smallint) OWNER TO postgres;

--
-- TOC entry 92 (class 1255 OID 16639)
-- Dependencies: 6
-- Name: gbt_intv_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_decompress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_intv_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_intv_decompress(internal) OWNER TO postgres;

--
-- TOC entry 93 (class 1255 OID 16640)
-- Dependencies: 6
-- Name: gbt_intv_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_intv_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_intv_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 94 (class 1255 OID 16641)
-- Dependencies: 6
-- Name: gbt_intv_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_intv_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_intv_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 96 (class 1255 OID 16643)
-- Dependencies: 6
-- Name: gbt_intv_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_intv_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_intv_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 95 (class 1255 OID 16642)
-- Dependencies: 1069 6
-- Name: gbt_intv_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_intv_union(bytea, internal) RETURNS gbtreekey32
    AS '$libdir/btree_gist', 'gbt_intv_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_intv_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 104 (class 1255 OID 16679)
-- Dependencies: 6
-- Name: gbt_macad_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_macad_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_macad_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_macad_compress(internal) OWNER TO postgres;

--
-- TOC entry 103 (class 1255 OID 16678)
-- Dependencies: 6
-- Name: gbt_macad_consistent(internal, macaddr, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_macad_consistent(internal, macaddr, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_macad_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_macad_consistent(internal, macaddr, smallint) OWNER TO postgres;

--
-- TOC entry 105 (class 1255 OID 16680)
-- Dependencies: 6
-- Name: gbt_macad_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_macad_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_macad_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_macad_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 106 (class 1255 OID 16681)
-- Dependencies: 6
-- Name: gbt_macad_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_macad_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_macad_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_macad_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 108 (class 1255 OID 16683)
-- Dependencies: 6
-- Name: gbt_macad_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_macad_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_macad_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_macad_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 107 (class 1255 OID 16682)
-- Dependencies: 1066 6
-- Name: gbt_macad_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_macad_union(bytea, internal) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbt_macad_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_macad_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 124 (class 1255 OID 16755)
-- Dependencies: 6
-- Name: gbt_numeric_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_numeric_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_numeric_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_numeric_compress(internal) OWNER TO postgres;

--
-- TOC entry 123 (class 1255 OID 16754)
-- Dependencies: 6
-- Name: gbt_numeric_consistent(internal, numeric, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_numeric_consistent(internal, numeric, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_numeric_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_numeric_consistent(internal, numeric, smallint) OWNER TO postgres;

--
-- TOC entry 125 (class 1255 OID 16756)
-- Dependencies: 6
-- Name: gbt_numeric_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_numeric_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_numeric_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_numeric_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 126 (class 1255 OID 16757)
-- Dependencies: 6
-- Name: gbt_numeric_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_numeric_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_numeric_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_numeric_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 128 (class 1255 OID 16759)
-- Dependencies: 6
-- Name: gbt_numeric_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_numeric_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_numeric_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_numeric_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 127 (class 1255 OID 16758)
-- Dependencies: 1072 6
-- Name: gbt_numeric_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_numeric_union(bytea, internal) RETURNS gbtreekey_var
    AS '$libdir/btree_gist', 'gbt_numeric_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_numeric_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 31 (class 1255 OID 16424)
-- Dependencies: 6
-- Name: gbt_oid_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_oid_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_oid_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_oid_compress(internal) OWNER TO postgres;

--
-- TOC entry 30 (class 1255 OID 16423)
-- Dependencies: 6
-- Name: gbt_oid_consistent(internal, oid, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_oid_consistent(internal, oid, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_oid_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_oid_consistent(internal, oid, smallint) OWNER TO postgres;

--
-- TOC entry 34 (class 1255 OID 16427)
-- Dependencies: 6
-- Name: gbt_oid_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_oid_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_oid_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_oid_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 35 (class 1255 OID 16428)
-- Dependencies: 6
-- Name: gbt_oid_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_oid_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_oid_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_oid_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 37 (class 1255 OID 16430)
-- Dependencies: 6
-- Name: gbt_oid_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_oid_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_oid_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_oid_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 36 (class 1255 OID 16429)
-- Dependencies: 1063 6
-- Name: gbt_oid_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_oid_union(bytea, internal) RETURNS gbtreekey8
    AS '$libdir/btree_gist', 'gbt_oid_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_oid_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 111 (class 1255 OID 16700)
-- Dependencies: 6
-- Name: gbt_text_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_text_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_text_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_text_compress(internal) OWNER TO postgres;

--
-- TOC entry 109 (class 1255 OID 16698)
-- Dependencies: 6
-- Name: gbt_text_consistent(internal, text, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_text_consistent(internal, text, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_text_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_text_consistent(internal, text, smallint) OWNER TO postgres;

--
-- TOC entry 113 (class 1255 OID 16702)
-- Dependencies: 6
-- Name: gbt_text_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_text_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_text_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_text_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 114 (class 1255 OID 16703)
-- Dependencies: 6
-- Name: gbt_text_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_text_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_text_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_text_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 116 (class 1255 OID 16705)
-- Dependencies: 6
-- Name: gbt_text_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_text_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_text_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_text_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 115 (class 1255 OID 16704)
-- Dependencies: 6 1072
-- Name: gbt_text_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_text_union(bytea, internal) RETURNS gbtreekey_var
    AS '$libdir/btree_gist', 'gbt_text_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_text_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 78 (class 1255 OID 16583)
-- Dependencies: 6
-- Name: gbt_time_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_time_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_time_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_time_compress(internal) OWNER TO postgres;

--
-- TOC entry 76 (class 1255 OID 16581)
-- Dependencies: 6
-- Name: gbt_time_consistent(internal, time without time zone, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_time_consistent(internal, time without time zone, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_time_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_time_consistent(internal, time without time zone, smallint) OWNER TO postgres;

--
-- TOC entry 80 (class 1255 OID 16585)
-- Dependencies: 6
-- Name: gbt_time_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_time_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_time_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_time_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 81 (class 1255 OID 16586)
-- Dependencies: 6
-- Name: gbt_time_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_time_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_time_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_time_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 83 (class 1255 OID 16588)
-- Dependencies: 6
-- Name: gbt_time_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_time_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_time_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_time_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 82 (class 1255 OID 16587)
-- Dependencies: 6 1066
-- Name: gbt_time_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_time_union(bytea, internal) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbt_time_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_time_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 79 (class 1255 OID 16584)
-- Dependencies: 6
-- Name: gbt_timetz_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_timetz_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_timetz_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_timetz_compress(internal) OWNER TO postgres;

--
-- TOC entry 77 (class 1255 OID 16582)
-- Dependencies: 6
-- Name: gbt_timetz_consistent(internal, time with time zone, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_timetz_consistent(internal, time with time zone, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_timetz_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_timetz_consistent(internal, time with time zone, smallint) OWNER TO postgres;

--
-- TOC entry 70 (class 1255 OID 16547)
-- Dependencies: 6
-- Name: gbt_ts_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_ts_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_ts_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_ts_compress(internal) OWNER TO postgres;

--
-- TOC entry 68 (class 1255 OID 16545)
-- Dependencies: 6
-- Name: gbt_ts_consistent(internal, timestamp without time zone, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_ts_consistent(internal, timestamp without time zone, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_ts_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_ts_consistent(internal, timestamp without time zone, smallint) OWNER TO postgres;

--
-- TOC entry 72 (class 1255 OID 16549)
-- Dependencies: 6
-- Name: gbt_ts_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_ts_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_ts_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gbt_ts_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 73 (class 1255 OID 16550)
-- Dependencies: 6
-- Name: gbt_ts_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_ts_picksplit(internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_ts_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_ts_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 75 (class 1255 OID 16552)
-- Dependencies: 6
-- Name: gbt_ts_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_ts_same(internal, internal, internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_ts_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_ts_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 74 (class 1255 OID 16551)
-- Dependencies: 1066 6
-- Name: gbt_ts_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_ts_union(bytea, internal) RETURNS gbtreekey16
    AS '$libdir/btree_gist', 'gbt_ts_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_ts_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 71 (class 1255 OID 16548)
-- Dependencies: 6
-- Name: gbt_tstz_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_tstz_compress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_tstz_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_tstz_compress(internal) OWNER TO postgres;

--
-- TOC entry 69 (class 1255 OID 16546)
-- Dependencies: 6
-- Name: gbt_tstz_consistent(internal, timestamp with time zone, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_tstz_consistent(internal, timestamp with time zone, smallint) RETURNS boolean
    AS '$libdir/btree_gist', 'gbt_tstz_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_tstz_consistent(internal, timestamp with time zone, smallint) OWNER TO postgres;

--
-- TOC entry 33 (class 1255 OID 16426)
-- Dependencies: 6
-- Name: gbt_var_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gbt_var_decompress(internal) RETURNS internal
    AS '$libdir/btree_gist', 'gbt_var_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gbt_var_decompress(internal) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 16969)
-- Dependencies: 6
-- Name: gc_to_sec(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gc_to_sec(double precision) RETURNS double precision
    AS $_$SELECT CASE WHEN $1 < 0 THEN 0::float8 WHEN $1/earth() > pi() THEN 2*earth() ELSE 2*earth()*sin($1/(2*earth())) END$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.gc_to_sec(double precision) OWNER TO postgres;

--
-- TOC entry 664 (class 1255 OID 18076)
-- Dependencies: 6
-- Name: gen_random_bytes(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_random_bytes(integer) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_random_bytes'
    LANGUAGE c STRICT;


ALTER FUNCTION public.gen_random_bytes(integer) OWNER TO postgres;

--
-- TOC entry 658 (class 1255 OID 18070)
-- Dependencies: 6
-- Name: gen_salt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_salt(text) RETURNS text
    AS '$libdir/pgcrypto', 'pg_gen_salt'
    LANGUAGE c STRICT;


ALTER FUNCTION public.gen_salt(text) OWNER TO postgres;

--
-- TOC entry 659 (class 1255 OID 18071)
-- Dependencies: 6
-- Name: gen_salt(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_salt(text, integer) RETURNS text
    AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
    LANGUAGE c STRICT;


ALTER FUNCTION public.gen_salt(text, integer) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16975)
-- Dependencies: 6
-- Name: geo_distance(point, point); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geo_distance(point, point) RETURNS double precision
    AS '$libdir/earthdistance', 'geo_distance'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.geo_distance(point, point) OWNER TO postgres;

--
-- TOC entry 628 (class 1255 OID 18007)
-- Dependencies: 6
-- Name: get_raw_page(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_raw_page(text, integer) RETURNS bytea
    AS '$libdir/pageinspect', 'get_raw_page'
    LANGUAGE c STRICT;


ALTER FUNCTION public.get_raw_page(text, integer) OWNER TO postgres;

--
-- TOC entry 725 (class 1255 OID 18181)
-- Dependencies: 6
-- Name: get_timetravel(name); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_timetravel(name) RETURNS integer
    AS '$libdir/timetravel', 'get_timetravel'
    LANGUAGE c STRICT;


ALTER FUNCTION public.get_timetravel(name) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 17015)
-- Dependencies: 6
-- Name: ghstore_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_compress(internal) RETURNS internal
    AS '$libdir/hstore', 'ghstore_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ghstore_compress(internal) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 17021)
-- Dependencies: 6
-- Name: ghstore_consistent(internal, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_consistent(internal, internal, integer) RETURNS boolean
    AS '$libdir/hstore', 'ghstore_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ghstore_consistent(internal, internal, integer) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 17016)
-- Dependencies: 6
-- Name: ghstore_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_decompress(internal) RETURNS internal
    AS '$libdir/hstore', 'ghstore_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ghstore_decompress(internal) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 17017)
-- Dependencies: 6
-- Name: ghstore_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/hstore', 'ghstore_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ghstore_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 17018)
-- Dependencies: 6
-- Name: ghstore_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_picksplit(internal, internal) RETURNS internal
    AS '$libdir/hstore', 'ghstore_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ghstore_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 17020)
-- Dependencies: 6
-- Name: ghstore_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_same(internal, internal, internal) RETURNS internal
    AS '$libdir/hstore', 'ghstore_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ghstore_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 17019)
-- Dependencies: 6
-- Name: ghstore_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ghstore_union(internal, internal) RETURNS internal
    AS '$libdir/hstore', 'ghstore_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ghstore_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 17036)
-- Dependencies: 6
-- Name: gin_consistent_hstore(internal, smallint, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gin_consistent_hstore(internal, smallint, internal) RETURNS internal
    AS '$libdir/hstore', 'gin_consistent_hstore'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gin_consistent_hstore(internal, smallint, internal) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 17034)
-- Dependencies: 6
-- Name: gin_extract_hstore(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gin_extract_hstore(internal, internal) RETURNS internal
    AS '$libdir/hstore', 'gin_extract_hstore'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gin_extract_hstore(internal, internal) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 17035)
-- Dependencies: 6
-- Name: gin_extract_hstore_query(internal, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gin_extract_hstore_query(internal, internal, smallint) RETURNS internal
    AS '$libdir/hstore', 'gin_extract_hstore_query'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gin_extract_hstore_query(internal, internal, smallint) OWNER TO postgres;

--
-- TOC entry 650 (class 1255 OID 18055)
-- Dependencies: 6
-- Name: gin_extract_trgm(text, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gin_extract_trgm(text, internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gin_extract_trgm'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gin_extract_trgm(text, internal) OWNER TO postgres;

--
-- TOC entry 651 (class 1255 OID 18056)
-- Dependencies: 6
-- Name: gin_extract_trgm(text, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gin_extract_trgm(text, internal, internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gin_extract_trgm'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gin_extract_trgm(text, internal, internal) OWNER TO postgres;

--
-- TOC entry 652 (class 1255 OID 18057)
-- Dependencies: 6
-- Name: gin_trgm_consistent(internal, internal, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gin_trgm_consistent(internal, internal, text) RETURNS internal
    AS '$libdir/pg_trgm', 'gin_trgm_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gin_trgm_consistent(internal, internal, text) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 17145)
-- Dependencies: 6
-- Name: ginint4_consistent(internal, smallint, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ginint4_consistent(internal, smallint, internal) RETURNS internal
    AS '$libdir/_int', 'ginint4_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ginint4_consistent(internal, smallint, internal) OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 17144)
-- Dependencies: 6
-- Name: ginint4_queryextract(internal, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ginint4_queryextract(internal, internal, smallint) RETURNS internal
    AS '$libdir/_int', 'ginint4_queryextract'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ginint4_queryextract(internal, internal, smallint) OWNER TO postgres;

--
-- TOC entry 712 (class 1255 OID 18141)
-- Dependencies: 6
-- Name: gseg_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_compress(internal) RETURNS internal
    AS '$libdir/seg', 'gseg_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gseg_compress(internal) OWNER TO postgres;

--
-- TOC entry 711 (class 1255 OID 18140)
-- Dependencies: 6 1145
-- Name: gseg_consistent(internal, seg, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_consistent(internal, seg, integer) RETURNS boolean
    AS '$libdir/seg', 'gseg_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gseg_consistent(internal, seg, integer) OWNER TO postgres;

--
-- TOC entry 713 (class 1255 OID 18142)
-- Dependencies: 6
-- Name: gseg_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_decompress(internal) RETURNS internal
    AS '$libdir/seg', 'gseg_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gseg_decompress(internal) OWNER TO postgres;

--
-- TOC entry 714 (class 1255 OID 18143)
-- Dependencies: 6
-- Name: gseg_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/seg', 'gseg_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gseg_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 715 (class 1255 OID 18144)
-- Dependencies: 6
-- Name: gseg_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_picksplit(internal, internal) RETURNS internal
    AS '$libdir/seg', 'gseg_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gseg_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 717 (class 1255 OID 18146)
-- Dependencies: 1145 1145 6
-- Name: gseg_same(seg, seg, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_same(seg, seg, internal) RETURNS internal
    AS '$libdir/seg', 'gseg_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gseg_same(seg, seg, internal) OWNER TO postgres;

--
-- TOC entry 716 (class 1255 OID 18145)
-- Dependencies: 1145 6
-- Name: gseg_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gseg_union(internal, internal) RETURNS seg
    AS '$libdir/seg', 'gseg_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gseg_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 644 (class 1255 OID 18039)
-- Dependencies: 6
-- Name: gtrgm_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_compress(internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gtrgm_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gtrgm_compress(internal) OWNER TO postgres;

--
-- TOC entry 643 (class 1255 OID 18038)
-- Dependencies: 1142 6
-- Name: gtrgm_consistent(gtrgm, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_consistent(gtrgm, internal, integer) RETURNS boolean
    AS '$libdir/pg_trgm', 'gtrgm_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gtrgm_consistent(gtrgm, internal, integer) OWNER TO postgres;

--
-- TOC entry 645 (class 1255 OID 18040)
-- Dependencies: 6
-- Name: gtrgm_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_decompress(internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gtrgm_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gtrgm_decompress(internal) OWNER TO postgres;

--
-- TOC entry 646 (class 1255 OID 18041)
-- Dependencies: 6
-- Name: gtrgm_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gtrgm_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.gtrgm_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 647 (class 1255 OID 18042)
-- Dependencies: 6
-- Name: gtrgm_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_picksplit(internal, internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gtrgm_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gtrgm_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 649 (class 1255 OID 18044)
-- Dependencies: 1142 6 1142
-- Name: gtrgm_same(gtrgm, gtrgm, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_same(gtrgm, gtrgm, internal) RETURNS internal
    AS '$libdir/pg_trgm', 'gtrgm_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gtrgm_same(gtrgm, gtrgm, internal) OWNER TO postgres;

--
-- TOC entry 648 (class 1255 OID 18043)
-- Dependencies: 6
-- Name: gtrgm_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gtrgm_union(bytea, internal) RETURNS integer[]
    AS '$libdir/pg_trgm', 'gtrgm_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.gtrgm_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 496 (class 1255 OID 17537)
-- Dependencies: 6 1099
-- Name: hashean13(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashean13(ean13) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashean13(ean13) OWNER TO postgres;

--
-- TOC entry 509 (class 1255 OID 17633)
-- Dependencies: 6 1111
-- Name: hashisbn(isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashisbn(isbn) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashisbn(isbn) OWNER TO postgres;

--
-- TOC entry 505 (class 1255 OID 17605)
-- Dependencies: 1102 6
-- Name: hashisbn13(isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashisbn13(isbn13) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashisbn13(isbn13) OWNER TO postgres;

--
-- TOC entry 517 (class 1255 OID 17689)
-- Dependencies: 6 1114
-- Name: hashismn(ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashismn(ismn) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashismn(ismn) OWNER TO postgres;

--
-- TOC entry 513 (class 1255 OID 17661)
-- Dependencies: 1105 6
-- Name: hashismn13(ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashismn13(ismn13) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashismn13(ismn13) OWNER TO postgres;

--
-- TOC entry 525 (class 1255 OID 17745)
-- Dependencies: 6 1117
-- Name: hashissn(issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashissn(issn) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashissn(issn) OWNER TO postgres;

--
-- TOC entry 521 (class 1255 OID 17717)
-- Dependencies: 1108 6
-- Name: hashissn13(issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashissn13(issn13) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashissn13(issn13) OWNER TO postgres;

--
-- TOC entry 529 (class 1255 OID 17773)
-- Dependencies: 6 1120
-- Name: hashupc(upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hashupc(upc) RETURNS integer
    AS $$hashint8$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.hashupc(upc) OWNER TO postgres;

--
-- TOC entry 630 (class 1255 OID 18009)
-- Dependencies: 6
-- Name: heap_page_items(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION heap_page_items(page bytea, OUT lp smallint, OUT lp_off smallint, OUT lp_flags smallint, OUT lp_len smallint, OUT t_xmin xid, OUT t_xmax xid, OUT t_field3 integer, OUT t_ctid tid, OUT t_infomask2 smallint, OUT t_infomask smallint, OUT t_hoff smallint, OUT t_bits text, OUT t_oid oid) RETURNS SETOF record
    AS '$libdir/pageinspect', 'heap_page_items'
    LANGUAGE c STRICT;


ALTER FUNCTION public.heap_page_items(page bytea, OUT lp smallint, OUT lp_off smallint, OUT lp_flags smallint, OUT lp_len smallint, OUT t_xmin xid, OUT t_xmax xid, OUT t_field3 integer, OUT t_ctid tid, OUT t_infomask2 smallint, OUT t_infomask smallint, OUT t_hoff smallint, OUT t_bits text, OUT t_oid oid) OWNER TO postgres;

--
-- TOC entry 655 (class 1255 OID 18067)
-- Dependencies: 6
-- Name: hmac(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hmac(text, text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.hmac(text, text, text) OWNER TO postgres;

--
-- TOC entry 656 (class 1255 OID 18068)
-- Dependencies: 6
-- Name: hmac(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hmac(bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.hmac(bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 16996)
-- Dependencies: 1087 1087 6 1087
-- Name: hs_concat(hstore, hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hs_concat(hstore, hstore) RETURNS hstore
    AS '$libdir/hstore', 'hs_concat'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.hs_concat(hstore, hstore) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 16999)
-- Dependencies: 1087 6 1087
-- Name: hs_contained(hstore, hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hs_contained(hstore, hstore) RETURNS boolean
    AS '$libdir/hstore', 'hs_contained'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.hs_contained(hstore, hstore) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 16998)
-- Dependencies: 1087 6 1087
-- Name: hs_contains(hstore, hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hs_contains(hstore, hstore) RETURNS boolean
    AS '$libdir/hstore', 'hs_contains'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.hs_contains(hstore, hstore) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 17071)
-- Dependencies: 6
-- Name: icount(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION icount(integer[]) RETURNS integer
    AS '$libdir/_int', 'icount'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.icount(integer[]) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 17078)
-- Dependencies: 6
-- Name: idx(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION idx(integer[], integer) RETURNS integer
    AS '$libdir/_int', 'idx'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.idx(integer[], integer) OWNER TO postgres;

--
-- TOC entry 570 (class 1255 OID 17853)
-- Dependencies: 6 1124 1124
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    AS '$libdir/ltree', 'ltree_index'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.index(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 571 (class 1255 OID 17854)
-- Dependencies: 6 1124 1124
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    AS '$libdir/ltree', 'ltree_index'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.index(ltree, ltree, integer) OWNER TO postgres;

--
-- TOC entry 719 (class 1255 OID 18175)
-- Dependencies: 6
-- Name: insert_username(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_username() RETURNS trigger
    AS '$libdir/insert_username', 'insert_username'
    LANGUAGE c;


ALTER FUNCTION public.insert_username() OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 17046)
-- Dependencies: 6
-- Name: int_agg_final_array(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION int_agg_final_array(integer[]) RETURNS integer[]
    AS '$libdir/int_aggregate', 'int_agg_final_array'
    LANGUAGE c;


ALTER FUNCTION public.int_agg_final_array(integer[]) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 17045)
-- Dependencies: 6
-- Name: int_agg_state(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION int_agg_state(integer[], integer) RETURNS integer[]
    AS '$libdir/int_aggregate', 'int_agg_state'
    LANGUAGE c;


ALTER FUNCTION public.int_agg_state(integer[], integer) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 17048)
-- Dependencies: 6
-- Name: int_array_enum(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION int_array_enum(integer[]) RETURNS SETOF integer
    AS '$libdir/int_aggregate', 'int_enum'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.int_array_enum(integer[]) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 17086)
-- Dependencies: 6
-- Name: intarray_del_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intarray_del_elem(integer[], integer) RETURNS integer[]
    AS '$libdir/_int', 'intarray_del_elem'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.intarray_del_elem(integer[], integer) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 17084)
-- Dependencies: 6
-- Name: intarray_push_array(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intarray_push_array(integer[], integer[]) RETURNS integer[]
    AS '$libdir/_int', 'intarray_push_array'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.intarray_push_array(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 17082)
-- Dependencies: 6
-- Name: intarray_push_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intarray_push_elem(integer[], integer) RETURNS integer[]
    AS '$libdir/_int', 'intarray_push_elem'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.intarray_push_elem(integer[], integer) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 17070)
-- Dependencies: 6
-- Name: intset(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intset(integer) RETURNS integer[]
    AS '$libdir/_int', 'intset'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.intset(integer) OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 17091)
-- Dependencies: 6
-- Name: intset_subtract(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intset_subtract(integer[], integer[]) RETURNS integer[]
    AS '$libdir/_int', 'intset_subtract'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.intset_subtract(integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 17088)
-- Dependencies: 6
-- Name: intset_union_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intset_union_elem(integer[], integer) RETURNS integer[]
    AS '$libdir/_int', 'intset_union_elem'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.intset_union_elem(integer[], integer) OWNER TO postgres;

--
-- TOC entry 546 (class 1255 OID 17820)
-- Dependencies: 1099 6
-- Name: is_valid(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(ean13) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(ean13) OWNER TO postgres;

--
-- TOC entry 547 (class 1255 OID 17821)
-- Dependencies: 6 1102
-- Name: is_valid(isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(isbn13) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(isbn13) OWNER TO postgres;

--
-- TOC entry 548 (class 1255 OID 17822)
-- Dependencies: 1105 6
-- Name: is_valid(ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(ismn13) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(ismn13) OWNER TO postgres;

--
-- TOC entry 549 (class 1255 OID 17823)
-- Dependencies: 1108 6
-- Name: is_valid(issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(issn13) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(issn13) OWNER TO postgres;

--
-- TOC entry 550 (class 1255 OID 17824)
-- Dependencies: 6 1111
-- Name: is_valid(isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(isbn) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(isbn) OWNER TO postgres;

--
-- TOC entry 551 (class 1255 OID 17825)
-- Dependencies: 6 1114
-- Name: is_valid(ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(ismn) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(ismn) OWNER TO postgres;

--
-- TOC entry 552 (class 1255 OID 17826)
-- Dependencies: 1117 6
-- Name: is_valid(issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(issn) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(issn) OWNER TO postgres;

--
-- TOC entry 553 (class 1255 OID 17827)
-- Dependencies: 6 1120
-- Name: is_valid(upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_valid(upc) RETURNS boolean
    AS '$libdir/isn', 'is_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.is_valid(upc) OWNER TO postgres;

--
-- TOC entry 534 (class 1255 OID 17788)
-- Dependencies: 6 1111 1099
-- Name: isbn(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isbn(ean13) RETURNS isbn
    AS '$libdir/isn', 'isbn_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isbn(ean13) OWNER TO postgres;

--
-- TOC entry 531 (class 1255 OID 17785)
-- Dependencies: 6 1102 1099
-- Name: isbn13(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isbn13(ean13) RETURNS isbn13
    AS '$libdir/isn', 'isbn_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isbn13(ean13) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 16993)
-- Dependencies: 6 1087
-- Name: isdefined(hstore, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isdefined(hstore, text) RETURNS boolean
    AS '$libdir/hstore', 'defined'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isdefined(hstore, text) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 16990)
-- Dependencies: 6 1087
-- Name: isexists(hstore, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isexists(hstore, text) RETURNS boolean
    AS '$libdir/hstore', 'exists'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isexists(hstore, text) OWNER TO postgres;

--
-- TOC entry 535 (class 1255 OID 17789)
-- Dependencies: 6 1114 1099
-- Name: ismn(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ismn(ean13) RETURNS ismn
    AS '$libdir/isn', 'ismn_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ismn(ean13) OWNER TO postgres;

--
-- TOC entry 532 (class 1255 OID 17786)
-- Dependencies: 6 1105 1099
-- Name: ismn13(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ismn13(ean13) RETURNS ismn13
    AS '$libdir/isn', 'ismn_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ismn13(ean13) OWNER TO postgres;

--
-- TOC entry 554 (class 1255 OID 17828)
-- Dependencies: 6
-- Name: isn_weak(boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isn_weak(boolean) RETURNS boolean
    AS '$libdir/isn', 'accept_weak_input'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isn_weak(boolean) OWNER TO postgres;

--
-- TOC entry 555 (class 1255 OID 17829)
-- Dependencies: 6
-- Name: isn_weak(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isn_weak() RETURNS boolean
    AS '$libdir/isn', 'weak_input_status'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.isn_weak() OWNER TO postgres;

--
-- TOC entry 329 (class 1255 OID 17193)
-- Dependencies: 6 1099 1099
-- Name: isneq(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 335 (class 1255 OID 17199)
-- Dependencies: 1099 6 1102
-- Name: isneq(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, isbn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 341 (class 1255 OID 17205)
-- Dependencies: 1099 6 1105
-- Name: isneq(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, ismn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 347 (class 1255 OID 17211)
-- Dependencies: 1099 6 1108
-- Name: isneq(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, issn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 353 (class 1255 OID 17217)
-- Dependencies: 1099 6 1111
-- Name: isneq(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, isbn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 359 (class 1255 OID 17223)
-- Dependencies: 6 1099 1114
-- Name: isneq(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, ismn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 365 (class 1255 OID 17229)
-- Dependencies: 1099 6 1117
-- Name: isneq(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, issn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, issn) OWNER TO postgres;

--
-- TOC entry 371 (class 1255 OID 17235)
-- Dependencies: 6 1099 1120
-- Name: isneq(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ean13, upc) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ean13, upc) OWNER TO postgres;

--
-- TOC entry 377 (class 1255 OID 17241)
-- Dependencies: 6 1102 1102
-- Name: isneq(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(isbn13, isbn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 383 (class 1255 OID 17247)
-- Dependencies: 1111 1102 6
-- Name: isneq(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(isbn13, isbn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 389 (class 1255 OID 17253)
-- Dependencies: 6 1099 1102
-- Name: isneq(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(isbn13, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 395 (class 1255 OID 17259)
-- Dependencies: 1111 1111 6
-- Name: isneq(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(isbn, isbn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 401 (class 1255 OID 17265)
-- Dependencies: 1102 1111 6
-- Name: isneq(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(isbn, isbn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 407 (class 1255 OID 17271)
-- Dependencies: 1099 6 1111
-- Name: isneq(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(isbn, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 413 (class 1255 OID 17277)
-- Dependencies: 1105 6 1105
-- Name: isneq(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ismn13, ismn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 419 (class 1255 OID 17283)
-- Dependencies: 1114 1105 6
-- Name: isneq(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ismn13, ismn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 425 (class 1255 OID 17289)
-- Dependencies: 1099 1105 6
-- Name: isneq(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ismn13, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 431 (class 1255 OID 17295)
-- Dependencies: 6 1114 1114
-- Name: isneq(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ismn, ismn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 437 (class 1255 OID 17301)
-- Dependencies: 6 1114 1105
-- Name: isneq(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ismn, ismn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 443 (class 1255 OID 17307)
-- Dependencies: 6 1114 1099
-- Name: isneq(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(ismn, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 449 (class 1255 OID 17313)
-- Dependencies: 6 1108 1108
-- Name: isneq(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(issn13, issn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 455 (class 1255 OID 17319)
-- Dependencies: 6 1108 1117
-- Name: isneq(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(issn13, issn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(issn13, issn) OWNER TO postgres;

--
-- TOC entry 461 (class 1255 OID 17325)
-- Dependencies: 1108 1099 6
-- Name: isneq(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(issn13, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 467 (class 1255 OID 17331)
-- Dependencies: 6 1117 1117
-- Name: isneq(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(issn, issn) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(issn, issn) OWNER TO postgres;

--
-- TOC entry 473 (class 1255 OID 17337)
-- Dependencies: 1117 6 1108
-- Name: isneq(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(issn, issn13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(issn, issn13) OWNER TO postgres;

--
-- TOC entry 479 (class 1255 OID 17343)
-- Dependencies: 1117 1099 6
-- Name: isneq(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(issn, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(issn, ean13) OWNER TO postgres;

--
-- TOC entry 485 (class 1255 OID 17349)
-- Dependencies: 1120 1120 6
-- Name: isneq(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(upc, upc) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(upc, upc) OWNER TO postgres;

--
-- TOC entry 491 (class 1255 OID 17355)
-- Dependencies: 6 1099 1120
-- Name: isneq(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isneq(upc, ean13) RETURNS boolean
    AS $$int8eq$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isneq(upc, ean13) OWNER TO postgres;

--
-- TOC entry 330 (class 1255 OID 17194)
-- Dependencies: 1099 6 1099
-- Name: isnge(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 336 (class 1255 OID 17200)
-- Dependencies: 1099 6 1102
-- Name: isnge(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, isbn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 342 (class 1255 OID 17206)
-- Dependencies: 1099 6 1105
-- Name: isnge(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, ismn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 348 (class 1255 OID 17212)
-- Dependencies: 1099 6 1108
-- Name: isnge(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, issn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 354 (class 1255 OID 17218)
-- Dependencies: 6 1099 1111
-- Name: isnge(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, isbn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 360 (class 1255 OID 17224)
-- Dependencies: 6 1099 1114
-- Name: isnge(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, ismn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 366 (class 1255 OID 17230)
-- Dependencies: 6 1099 1117
-- Name: isnge(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, issn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, issn) OWNER TO postgres;

--
-- TOC entry 372 (class 1255 OID 17236)
-- Dependencies: 6 1099 1120
-- Name: isnge(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ean13, upc) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ean13, upc) OWNER TO postgres;

--
-- TOC entry 378 (class 1255 OID 17242)
-- Dependencies: 6 1102 1102
-- Name: isnge(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(isbn13, isbn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 384 (class 1255 OID 17248)
-- Dependencies: 6 1111 1102
-- Name: isnge(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(isbn13, isbn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 390 (class 1255 OID 17254)
-- Dependencies: 6 1102 1099
-- Name: isnge(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(isbn13, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 396 (class 1255 OID 17260)
-- Dependencies: 1111 6 1111
-- Name: isnge(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(isbn, isbn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 402 (class 1255 OID 17266)
-- Dependencies: 1111 6 1102
-- Name: isnge(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(isbn, isbn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 408 (class 1255 OID 17272)
-- Dependencies: 1099 6 1111
-- Name: isnge(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(isbn, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 414 (class 1255 OID 17278)
-- Dependencies: 1105 6 1105
-- Name: isnge(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ismn13, ismn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 420 (class 1255 OID 17284)
-- Dependencies: 6 1105 1114
-- Name: isnge(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ismn13, ismn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 426 (class 1255 OID 17290)
-- Dependencies: 1105 6 1099
-- Name: isnge(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ismn13, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 432 (class 1255 OID 17296)
-- Dependencies: 1114 6 1114
-- Name: isnge(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ismn, ismn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 438 (class 1255 OID 17302)
-- Dependencies: 6 1114 1105
-- Name: isnge(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ismn, ismn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 444 (class 1255 OID 17308)
-- Dependencies: 6 1114 1099
-- Name: isnge(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(ismn, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 450 (class 1255 OID 17314)
-- Dependencies: 6 1108 1108
-- Name: isnge(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(issn13, issn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 456 (class 1255 OID 17320)
-- Dependencies: 6 1108 1117
-- Name: isnge(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(issn13, issn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(issn13, issn) OWNER TO postgres;

--
-- TOC entry 462 (class 1255 OID 17326)
-- Dependencies: 6 1108 1099
-- Name: isnge(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(issn13, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 468 (class 1255 OID 17332)
-- Dependencies: 1117 1117 6
-- Name: isnge(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(issn, issn) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(issn, issn) OWNER TO postgres;

--
-- TOC entry 474 (class 1255 OID 17338)
-- Dependencies: 1108 6 1117
-- Name: isnge(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(issn, issn13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(issn, issn13) OWNER TO postgres;

--
-- TOC entry 480 (class 1255 OID 17344)
-- Dependencies: 1099 6 1117
-- Name: isnge(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(issn, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(issn, ean13) OWNER TO postgres;

--
-- TOC entry 486 (class 1255 OID 17350)
-- Dependencies: 1120 1120 6
-- Name: isnge(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(upc, upc) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(upc, upc) OWNER TO postgres;

--
-- TOC entry 492 (class 1255 OID 17356)
-- Dependencies: 1099 6 1120
-- Name: isnge(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnge(upc, ean13) RETURNS boolean
    AS $$int8ge$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnge(upc, ean13) OWNER TO postgres;

--
-- TOC entry 331 (class 1255 OID 17195)
-- Dependencies: 1099 6 1099
-- Name: isngt(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 337 (class 1255 OID 17201)
-- Dependencies: 6 1099 1102
-- Name: isngt(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, isbn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 343 (class 1255 OID 17207)
-- Dependencies: 1105 6 1099
-- Name: isngt(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, ismn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 349 (class 1255 OID 17213)
-- Dependencies: 1099 6 1108
-- Name: isngt(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, issn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 355 (class 1255 OID 17219)
-- Dependencies: 6 1099 1111
-- Name: isngt(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, isbn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 361 (class 1255 OID 17225)
-- Dependencies: 1099 6 1114
-- Name: isngt(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, ismn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 367 (class 1255 OID 17231)
-- Dependencies: 6 1117 1099
-- Name: isngt(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, issn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, issn) OWNER TO postgres;

--
-- TOC entry 373 (class 1255 OID 17237)
-- Dependencies: 1120 6 1099
-- Name: isngt(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ean13, upc) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ean13, upc) OWNER TO postgres;

--
-- TOC entry 379 (class 1255 OID 17243)
-- Dependencies: 1102 1102 6
-- Name: isngt(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(isbn13, isbn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 385 (class 1255 OID 17249)
-- Dependencies: 6 1111 1102
-- Name: isngt(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(isbn13, isbn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 391 (class 1255 OID 17255)
-- Dependencies: 6 1102 1099
-- Name: isngt(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(isbn13, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 397 (class 1255 OID 17261)
-- Dependencies: 1111 6 1111
-- Name: isngt(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(isbn, isbn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 403 (class 1255 OID 17267)
-- Dependencies: 6 1111 1102
-- Name: isngt(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(isbn, isbn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 409 (class 1255 OID 17273)
-- Dependencies: 6 1099 1111
-- Name: isngt(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(isbn, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 415 (class 1255 OID 17279)
-- Dependencies: 1105 1105 6
-- Name: isngt(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ismn13, ismn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 421 (class 1255 OID 17285)
-- Dependencies: 1105 6 1114
-- Name: isngt(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ismn13, ismn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 427 (class 1255 OID 17291)
-- Dependencies: 6 1105 1099
-- Name: isngt(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ismn13, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 433 (class 1255 OID 17297)
-- Dependencies: 6 1114 1114
-- Name: isngt(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ismn, ismn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 439 (class 1255 OID 17303)
-- Dependencies: 6 1114 1105
-- Name: isngt(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ismn, ismn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 445 (class 1255 OID 17309)
-- Dependencies: 6 1114 1099
-- Name: isngt(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(ismn, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 451 (class 1255 OID 17315)
-- Dependencies: 6 1108 1108
-- Name: isngt(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(issn13, issn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 457 (class 1255 OID 17321)
-- Dependencies: 6 1108 1117
-- Name: isngt(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(issn13, issn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(issn13, issn) OWNER TO postgres;

--
-- TOC entry 463 (class 1255 OID 17327)
-- Dependencies: 6 1108 1099
-- Name: isngt(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(issn13, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 469 (class 1255 OID 17333)
-- Dependencies: 6 1117 1117
-- Name: isngt(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(issn, issn) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(issn, issn) OWNER TO postgres;

--
-- TOC entry 475 (class 1255 OID 17339)
-- Dependencies: 1108 6 1117
-- Name: isngt(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(issn, issn13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(issn, issn13) OWNER TO postgres;

--
-- TOC entry 481 (class 1255 OID 17345)
-- Dependencies: 6 1099 1117
-- Name: isngt(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(issn, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(issn, ean13) OWNER TO postgres;

--
-- TOC entry 487 (class 1255 OID 17351)
-- Dependencies: 1120 1120 6
-- Name: isngt(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(upc, upc) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(upc, upc) OWNER TO postgres;

--
-- TOC entry 493 (class 1255 OID 17357)
-- Dependencies: 6 1099 1120
-- Name: isngt(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isngt(upc, ean13) RETURNS boolean
    AS $$int8gt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isngt(upc, ean13) OWNER TO postgres;

--
-- TOC entry 328 (class 1255 OID 17192)
-- Dependencies: 1099 6 1099
-- Name: isnle(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 334 (class 1255 OID 17198)
-- Dependencies: 1099 6 1102
-- Name: isnle(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, isbn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 340 (class 1255 OID 17204)
-- Dependencies: 1099 6 1105
-- Name: isnle(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, ismn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 346 (class 1255 OID 17210)
-- Dependencies: 1099 6 1108
-- Name: isnle(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, issn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 352 (class 1255 OID 17216)
-- Dependencies: 1099 6 1111
-- Name: isnle(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, isbn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 358 (class 1255 OID 17222)
-- Dependencies: 1099 6 1114
-- Name: isnle(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, ismn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 364 (class 1255 OID 17228)
-- Dependencies: 6 1117 1099
-- Name: isnle(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, issn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, issn) OWNER TO postgres;

--
-- TOC entry 370 (class 1255 OID 17234)
-- Dependencies: 1120 6 1099
-- Name: isnle(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ean13, upc) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ean13, upc) OWNER TO postgres;

--
-- TOC entry 376 (class 1255 OID 17240)
-- Dependencies: 1102 6 1102
-- Name: isnle(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(isbn13, isbn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 382 (class 1255 OID 17246)
-- Dependencies: 6 1111 1102
-- Name: isnle(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(isbn13, isbn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 388 (class 1255 OID 17252)
-- Dependencies: 1099 6 1102
-- Name: isnle(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(isbn13, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 394 (class 1255 OID 17258)
-- Dependencies: 1111 1111 6
-- Name: isnle(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(isbn, isbn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 400 (class 1255 OID 17264)
-- Dependencies: 1102 1111 6
-- Name: isnle(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(isbn, isbn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 406 (class 1255 OID 17270)
-- Dependencies: 6 1099 1111
-- Name: isnle(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(isbn, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 412 (class 1255 OID 17276)
-- Dependencies: 6 1105 1105
-- Name: isnle(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ismn13, ismn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 418 (class 1255 OID 17282)
-- Dependencies: 1114 1105 6
-- Name: isnle(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ismn13, ismn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 424 (class 1255 OID 17288)
-- Dependencies: 1099 6 1105
-- Name: isnle(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ismn13, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 430 (class 1255 OID 17294)
-- Dependencies: 6 1114 1114
-- Name: isnle(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ismn, ismn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 436 (class 1255 OID 17300)
-- Dependencies: 6 1114 1105
-- Name: isnle(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ismn, ismn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 442 (class 1255 OID 17306)
-- Dependencies: 6 1114 1099
-- Name: isnle(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(ismn, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 448 (class 1255 OID 17312)
-- Dependencies: 6 1108 1108
-- Name: isnle(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(issn13, issn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 454 (class 1255 OID 17318)
-- Dependencies: 6 1108 1117
-- Name: isnle(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(issn13, issn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(issn13, issn) OWNER TO postgres;

--
-- TOC entry 460 (class 1255 OID 17324)
-- Dependencies: 1108 6 1099
-- Name: isnle(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(issn13, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 466 (class 1255 OID 17330)
-- Dependencies: 1117 6 1117
-- Name: isnle(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(issn, issn) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(issn, issn) OWNER TO postgres;

--
-- TOC entry 472 (class 1255 OID 17336)
-- Dependencies: 1117 1108 6
-- Name: isnle(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(issn, issn13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(issn, issn13) OWNER TO postgres;

--
-- TOC entry 478 (class 1255 OID 17342)
-- Dependencies: 6 1117 1099
-- Name: isnle(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(issn, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(issn, ean13) OWNER TO postgres;

--
-- TOC entry 484 (class 1255 OID 17348)
-- Dependencies: 1120 1120 6
-- Name: isnle(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(upc, upc) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(upc, upc) OWNER TO postgres;

--
-- TOC entry 490 (class 1255 OID 17354)
-- Dependencies: 1120 1099 6
-- Name: isnle(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnle(upc, ean13) RETURNS boolean
    AS $$int8le$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnle(upc, ean13) OWNER TO postgres;

--
-- TOC entry 327 (class 1255 OID 17191)
-- Dependencies: 1099 6 1099
-- Name: isnlt(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 333 (class 1255 OID 17197)
-- Dependencies: 1099 6 1102
-- Name: isnlt(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, isbn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 339 (class 1255 OID 17203)
-- Dependencies: 1099 6 1105
-- Name: isnlt(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, ismn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 345 (class 1255 OID 17209)
-- Dependencies: 1108 6 1099
-- Name: isnlt(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, issn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 351 (class 1255 OID 17215)
-- Dependencies: 1111 1099 6
-- Name: isnlt(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, isbn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 357 (class 1255 OID 17221)
-- Dependencies: 1114 1099 6
-- Name: isnlt(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, ismn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 363 (class 1255 OID 17227)
-- Dependencies: 1117 1099 6
-- Name: isnlt(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, issn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, issn) OWNER TO postgres;

--
-- TOC entry 369 (class 1255 OID 17233)
-- Dependencies: 6 1099 1120
-- Name: isnlt(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ean13, upc) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ean13, upc) OWNER TO postgres;

--
-- TOC entry 375 (class 1255 OID 17239)
-- Dependencies: 1102 6 1102
-- Name: isnlt(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(isbn13, isbn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 381 (class 1255 OID 17245)
-- Dependencies: 1102 6 1111
-- Name: isnlt(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(isbn13, isbn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 387 (class 1255 OID 17251)
-- Dependencies: 6 1102 1099
-- Name: isnlt(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(isbn13, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 393 (class 1255 OID 17257)
-- Dependencies: 6 1111 1111
-- Name: isnlt(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(isbn, isbn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 399 (class 1255 OID 17263)
-- Dependencies: 6 1102 1111
-- Name: isnlt(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(isbn, isbn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 405 (class 1255 OID 17269)
-- Dependencies: 1099 1111 6
-- Name: isnlt(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(isbn, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 411 (class 1255 OID 17275)
-- Dependencies: 1105 6 1105
-- Name: isnlt(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ismn13, ismn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 417 (class 1255 OID 17281)
-- Dependencies: 1114 1105 6
-- Name: isnlt(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ismn13, ismn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 423 (class 1255 OID 17287)
-- Dependencies: 1099 1105 6
-- Name: isnlt(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ismn13, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 429 (class 1255 OID 17293)
-- Dependencies: 6 1114 1114
-- Name: isnlt(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ismn, ismn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 435 (class 1255 OID 17299)
-- Dependencies: 6 1114 1105
-- Name: isnlt(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ismn, ismn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 441 (class 1255 OID 17305)
-- Dependencies: 6 1114 1099
-- Name: isnlt(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(ismn, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 447 (class 1255 OID 17311)
-- Dependencies: 6 1108 1108
-- Name: isnlt(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(issn13, issn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 453 (class 1255 OID 17317)
-- Dependencies: 6 1108 1117
-- Name: isnlt(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(issn13, issn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(issn13, issn) OWNER TO postgres;

--
-- TOC entry 459 (class 1255 OID 17323)
-- Dependencies: 6 1099 1108
-- Name: isnlt(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(issn13, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 465 (class 1255 OID 17329)
-- Dependencies: 6 1117 1117
-- Name: isnlt(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(issn, issn) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(issn, issn) OWNER TO postgres;

--
-- TOC entry 471 (class 1255 OID 17335)
-- Dependencies: 1108 1117 6
-- Name: isnlt(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(issn, issn13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(issn, issn13) OWNER TO postgres;

--
-- TOC entry 477 (class 1255 OID 17341)
-- Dependencies: 6 1117 1099
-- Name: isnlt(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(issn, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(issn, ean13) OWNER TO postgres;

--
-- TOC entry 483 (class 1255 OID 17347)
-- Dependencies: 1120 1120 6
-- Name: isnlt(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(upc, upc) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(upc, upc) OWNER TO postgres;

--
-- TOC entry 489 (class 1255 OID 17353)
-- Dependencies: 1099 6 1120
-- Name: isnlt(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnlt(upc, ean13) RETURNS boolean
    AS $$int8lt$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnlt(upc, ean13) OWNER TO postgres;

--
-- TOC entry 332 (class 1255 OID 17196)
-- Dependencies: 1099 6 1099
-- Name: isnne(ean13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, ean13) OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 17202)
-- Dependencies: 1102 6 1099
-- Name: isnne(ean13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, isbn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 344 (class 1255 OID 17208)
-- Dependencies: 6 1099 1105
-- Name: isnne(ean13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, ismn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 350 (class 1255 OID 17214)
-- Dependencies: 1108 6 1099
-- Name: isnne(ean13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, issn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, issn13) OWNER TO postgres;

--
-- TOC entry 356 (class 1255 OID 17220)
-- Dependencies: 6 1099 1111
-- Name: isnne(ean13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, isbn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, isbn) OWNER TO postgres;

--
-- TOC entry 362 (class 1255 OID 17226)
-- Dependencies: 1099 1114 6
-- Name: isnne(ean13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, ismn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, ismn) OWNER TO postgres;

--
-- TOC entry 368 (class 1255 OID 17232)
-- Dependencies: 1117 6 1099
-- Name: isnne(ean13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, issn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, issn) OWNER TO postgres;

--
-- TOC entry 374 (class 1255 OID 17238)
-- Dependencies: 1120 1099 6
-- Name: isnne(ean13, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ean13, upc) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ean13, upc) OWNER TO postgres;

--
-- TOC entry 380 (class 1255 OID 17244)
-- Dependencies: 1102 1102 6
-- Name: isnne(isbn13, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(isbn13, isbn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 386 (class 1255 OID 17250)
-- Dependencies: 1111 6 1102
-- Name: isnne(isbn13, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(isbn13, isbn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 392 (class 1255 OID 17256)
-- Dependencies: 1102 6 1099
-- Name: isnne(isbn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(isbn13, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 398 (class 1255 OID 17262)
-- Dependencies: 1111 6 1111
-- Name: isnne(isbn, isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(isbn, isbn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(isbn, isbn) OWNER TO postgres;

--
-- TOC entry 404 (class 1255 OID 17268)
-- Dependencies: 1111 6 1102
-- Name: isnne(isbn, isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(isbn, isbn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 410 (class 1255 OID 17274)
-- Dependencies: 6 1099 1111
-- Name: isnne(isbn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(isbn, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(isbn, ean13) OWNER TO postgres;

--
-- TOC entry 416 (class 1255 OID 17280)
-- Dependencies: 1105 1105 6
-- Name: isnne(ismn13, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ismn13, ismn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 422 (class 1255 OID 17286)
-- Dependencies: 1105 6 1114
-- Name: isnne(ismn13, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ismn13, ismn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 428 (class 1255 OID 17292)
-- Dependencies: 6 1105 1099
-- Name: isnne(ismn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ismn13, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 434 (class 1255 OID 17298)
-- Dependencies: 6 1114 1114
-- Name: isnne(ismn, ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ismn, ismn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ismn, ismn) OWNER TO postgres;

--
-- TOC entry 440 (class 1255 OID 17304)
-- Dependencies: 6 1114 1105
-- Name: isnne(ismn, ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ismn, ismn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 446 (class 1255 OID 17310)
-- Dependencies: 6 1114 1099
-- Name: isnne(ismn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(ismn, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(ismn, ean13) OWNER TO postgres;

--
-- TOC entry 452 (class 1255 OID 17316)
-- Dependencies: 6 1108 1108
-- Name: isnne(issn13, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(issn13, issn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(issn13, issn13) OWNER TO postgres;

--
-- TOC entry 458 (class 1255 OID 17322)
-- Dependencies: 6 1108 1117
-- Name: isnne(issn13, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(issn13, issn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(issn13, issn) OWNER TO postgres;

--
-- TOC entry 464 (class 1255 OID 17328)
-- Dependencies: 6 1099 1108
-- Name: isnne(issn13, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(issn13, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(issn13, ean13) OWNER TO postgres;

--
-- TOC entry 470 (class 1255 OID 17334)
-- Dependencies: 6 1117 1117
-- Name: isnne(issn, issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(issn, issn) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(issn, issn) OWNER TO postgres;

--
-- TOC entry 476 (class 1255 OID 17340)
-- Dependencies: 1117 6 1108
-- Name: isnne(issn, issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(issn, issn13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(issn, issn13) OWNER TO postgres;

--
-- TOC entry 482 (class 1255 OID 17346)
-- Dependencies: 1099 6 1117
-- Name: isnne(issn, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(issn, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(issn, ean13) OWNER TO postgres;

--
-- TOC entry 488 (class 1255 OID 17352)
-- Dependencies: 1120 1120 6
-- Name: isnne(upc, upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(upc, upc) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(upc, upc) OWNER TO postgres;

--
-- TOC entry 494 (class 1255 OID 17358)
-- Dependencies: 1120 6 1099
-- Name: isnne(upc, ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isnne(upc, ean13) RETURNS boolean
    AS $$int8ne$$
    LANGUAGE internal IMMUTABLE STRICT;


ALTER FUNCTION public.isnne(upc, ean13) OWNER TO postgres;

--
-- TOC entry 536 (class 1255 OID 17790)
-- Dependencies: 6 1117 1099
-- Name: issn(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION issn(ean13) RETURNS issn
    AS '$libdir/isn', 'issn_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.issn(ean13) OWNER TO postgres;

--
-- TOC entry 533 (class 1255 OID 17787)
-- Dependencies: 6 1108 1099
-- Name: issn13(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION issn13(ean13) RETURNS issn13
    AS '$libdir/isn', 'issn_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.issn13(ean13) OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 16971)
-- Dependencies: 6 1083
-- Name: latitude(earth); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION latitude(earth) RETURNS double precision
    AS $_$SELECT CASE WHEN cube_ll_coord($1, 3)/earth() < -1 THEN -90::float8 WHEN cube_ll_coord($1, 3)/earth() > 1 THEN 90::float8 ELSE degrees(asin(cube_ll_coord($1, 3)/earth())) END$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.latitude(earth) OWNER TO postgres;

--
-- TOC entry 575 (class 1255 OID 17858)
-- Dependencies: 1124 6 1126
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    AS '$libdir/ltree', '_lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree[]) OWNER TO postgres;

--
-- TOC entry 576 (class 1255 OID 17859)
-- Dependencies: 1124 1124 1124 6
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 577 (class 1255 OID 17860)
-- Dependencies: 6 1124 1124 1124 1124
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree, ltree) OWNER TO postgres;

--
-- TOC entry 578 (class 1255 OID 17861)
-- Dependencies: 1124 1124 1124 1124 6 1124
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree) OWNER TO postgres;

--
-- TOC entry 579 (class 1255 OID 17862)
-- Dependencies: 1124 1124 1124 1124 1124 6 1124
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree) OWNER TO postgres;

--
-- TOC entry 580 (class 1255 OID 17863)
-- Dependencies: 6 1124 1124 1124 1124 1124 1124 1124
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree, ltree) OWNER TO postgres;

--
-- TOC entry 581 (class 1255 OID 17864)
-- Dependencies: 6 1124 1124 1124 1124 1124 1124 1124 1124
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) OWNER TO postgres;

--
-- TOC entry 582 (class 1255 OID 17865)
-- Dependencies: 6 1124 1124 1124 1124 1124 1124 1124 1124 1124
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'lca'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 16977)
-- Dependencies: 6
-- Name: levenshtein(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION levenshtein(text, text) RETURNS integer
    AS '$libdir/fuzzystrmatch', 'levenshtein'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.levenshtein(text, text) OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 16970)
-- Dependencies: 6 1083
-- Name: ll_to_earth(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ll_to_earth(double precision, double precision) RETURNS earth
    AS $_$SELECT cube(cube(cube(earth()*cos(radians($1))*cos(radians($2))),earth()*cos(radians($1))*sin(radians($2))),earth()*sin(radians($1)))::earth$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.ll_to_earth(double precision, double precision) OWNER TO postgres;

--
-- TOC entry 557 (class 1255 OID 17832)
-- Dependencies: 6
-- Name: lo_manage(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lo_manage() RETURNS trigger
    AS '$libdir/lo', 'lo_manage'
    LANGUAGE c;


ALTER FUNCTION public.lo_manage() OWNER TO postgres;

--
-- TOC entry 556 (class 1255 OID 17831)
-- Dependencies: 6 1123
-- Name: lo_oid(lo); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lo_oid(lo) RETURNS oid
    AS $_$SELECT $1::pg_catalog.oid$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.lo_oid(lo) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 16972)
-- Dependencies: 1083 6
-- Name: longitude(earth); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION longitude(earth) RETURNS double precision
    AS $_$SELECT degrees(atan2(cube_ll_coord($1, 2), cube_ll_coord($1, 1)))$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.longitude(earth) OWNER TO postgres;

--
-- TOC entry 593 (class 1255 OID 17897)
-- Dependencies: 6 1124 1129
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    AS '$libdir/ltree', 'lt_q_regex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lt_q_regex(ltree, lquery[]) OWNER TO postgres;

--
-- TOC entry 594 (class 1255 OID 17898)
-- Dependencies: 6 1129 1124
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    AS '$libdir/ltree', 'lt_q_rregex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.lt_q_rregex(lquery[], ltree) OWNER TO postgres;

--
-- TOC entry 591 (class 1255 OID 17891)
-- Dependencies: 6 1124 1127
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    AS '$libdir/ltree', 'ltq_regex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltq_regex(ltree, lquery) OWNER TO postgres;

--
-- TOC entry 592 (class 1255 OID 17892)
-- Dependencies: 6 1127 1124
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltq_rregex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltq_rregex(lquery, ltree) OWNER TO postgres;

--
-- TOC entry 573 (class 1255 OID 17856)
-- Dependencies: 1124 6
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    AS '$libdir/ltree', 'ltree2text'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree2text(ltree) OWNER TO postgres;

--
-- TOC entry 585 (class 1255 OID 17868)
-- Dependencies: 6 1124 1124 1124
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    AS '$libdir/ltree', 'ltree_addltree'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_addltree(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 586 (class 1255 OID 17869)
-- Dependencies: 6 1124 1124
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    AS '$libdir/ltree', 'ltree_addtext'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_addtext(ltree, text) OWNER TO postgres;

--
-- TOC entry 560 (class 1255 OID 17837)
-- Dependencies: 1124 6 1124
-- Name: ltree_cmp(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_cmp(ltree, ltree) RETURNS integer
    AS '$libdir/ltree', 'ltree_cmp'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_cmp(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 602 (class 1255 OID 17918)
-- Dependencies: 6
-- Name: ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_compress(internal) RETURNS internal
    AS '$libdir/ltree', 'ltree_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ltree_compress(internal) OWNER TO postgres;

--
-- TOC entry 601 (class 1255 OID 17917)
-- Dependencies: 6
-- Name: ltree_consistent(internal, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_consistent(internal, internal, smallint) RETURNS boolean
    AS '$libdir/ltree', 'ltree_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ltree_consistent(internal, internal, smallint) OWNER TO postgres;

--
-- TOC entry 603 (class 1255 OID 17919)
-- Dependencies: 6
-- Name: ltree_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_decompress(internal) RETURNS internal
    AS '$libdir/ltree', 'ltree_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ltree_decompress(internal) OWNER TO postgres;

--
-- TOC entry 563 (class 1255 OID 17840)
-- Dependencies: 1124 1124 6
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_eq'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_eq(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 564 (class 1255 OID 17841)
-- Dependencies: 1124 1124 6
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_ge'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_ge(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 565 (class 1255 OID 17842)
-- Dependencies: 1124 6 1124
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_gt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_gt(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 583 (class 1255 OID 17866)
-- Dependencies: 6 1124 1124
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_isparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_isparent(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 562 (class 1255 OID 17839)
-- Dependencies: 1124 6 1124
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_le'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_le(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 561 (class 1255 OID 17838)
-- Dependencies: 1124 1124 6
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_lt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_lt(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 566 (class 1255 OID 17843)
-- Dependencies: 1124 6 1124
-- Name: ltree_ne(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_ne(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_ne'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_ne(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 604 (class 1255 OID 17920)
-- Dependencies: 6
-- Name: ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/ltree', 'ltree_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 605 (class 1255 OID 17921)
-- Dependencies: 6
-- Name: ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_picksplit(internal, internal) RETURNS internal
    AS '$libdir/ltree', 'ltree_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ltree_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 584 (class 1255 OID 17867)
-- Dependencies: 6 1124 1124
-- Name: ltree_risparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_risparent(ltree, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltree_risparent'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_risparent(ltree, ltree) OWNER TO postgres;

--
-- TOC entry 607 (class 1255 OID 17923)
-- Dependencies: 6
-- Name: ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_same(internal, internal, internal) RETURNS internal
    AS '$libdir/ltree', 'ltree_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ltree_same(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 587 (class 1255 OID 17870)
-- Dependencies: 6 1124 1124
-- Name: ltree_textadd(text, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_textadd(text, ltree) RETURNS ltree
    AS '$libdir/ltree', 'ltree_textadd'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltree_textadd(text, ltree) OWNER TO postgres;

--
-- TOC entry 606 (class 1255 OID 17922)
-- Dependencies: 6
-- Name: ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltree_union(internal, internal) RETURNS integer
    AS '$libdir/ltree', 'ltree_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.ltree_union(internal, internal) OWNER TO postgres;

--
-- TOC entry 588 (class 1255 OID 17871)
-- Dependencies: 6
-- Name: ltreeparentsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltreeparentsel(internal, oid, internal, integer) RETURNS double precision
    AS '$libdir/ltree', 'ltreeparentsel'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltreeparentsel(internal, oid, internal, integer) OWNER TO postgres;

--
-- TOC entry 597 (class 1255 OID 17907)
-- Dependencies: 6 1124 1130
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    AS '$libdir/ltree', 'ltxtq_exec'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltxtq_exec(ltree, ltxtquery) OWNER TO postgres;

--
-- TOC entry 598 (class 1255 OID 17908)
-- Dependencies: 6 1130 1124
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    AS '$libdir/ltree', 'ltxtq_rexec'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.ltxtq_rexec(ltxtquery, ltree) OWNER TO postgres;

--
-- TOC entry 538 (class 1255 OID 17812)
-- Dependencies: 6 1099 1099
-- Name: make_valid(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(ean13) RETURNS ean13
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(ean13) OWNER TO postgres;

--
-- TOC entry 539 (class 1255 OID 17813)
-- Dependencies: 1102 1102 6
-- Name: make_valid(isbn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(isbn13) RETURNS isbn13
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(isbn13) OWNER TO postgres;

--
-- TOC entry 540 (class 1255 OID 17814)
-- Dependencies: 1105 1105 6
-- Name: make_valid(ismn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(ismn13) RETURNS ismn13
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(ismn13) OWNER TO postgres;

--
-- TOC entry 541 (class 1255 OID 17815)
-- Dependencies: 1108 6 1108
-- Name: make_valid(issn13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(issn13) RETURNS issn13
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(issn13) OWNER TO postgres;

--
-- TOC entry 542 (class 1255 OID 17816)
-- Dependencies: 6 1111 1111
-- Name: make_valid(isbn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(isbn) RETURNS isbn
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(isbn) OWNER TO postgres;

--
-- TOC entry 543 (class 1255 OID 17817)
-- Dependencies: 1114 6 1114
-- Name: make_valid(ismn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(ismn) RETURNS ismn
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(ismn) OWNER TO postgres;

--
-- TOC entry 544 (class 1255 OID 17818)
-- Dependencies: 1117 6 1117
-- Name: make_valid(issn); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(issn) RETURNS issn
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(issn) OWNER TO postgres;

--
-- TOC entry 545 (class 1255 OID 17819)
-- Dependencies: 1120 6 1120
-- Name: make_valid(upc); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_valid(upc) RETURNS upc
    AS '$libdir/isn', 'make_valid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.make_valid(upc) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16978)
-- Dependencies: 6
-- Name: metaphone(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION metaphone(text, integer) RETURNS text
    AS '$libdir/fuzzystrmatch', 'metaphone'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.metaphone(text, integer) OWNER TO postgres;

--
-- TOC entry 720 (class 1255 OID 18176)
-- Dependencies: 6
-- Name: moddatetime(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION moddatetime() RETURNS trigger
    AS '$libdir/moddatetime', 'moddatetime'
    LANGUAGE c;


ALTER FUNCTION public.moddatetime() OWNER TO postgres;

--
-- TOC entry 145 (class 1255 OID 16848)
-- Dependencies: 6 1075
-- Name: ne(chkpass, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ne(chkpass, text) RETURNS boolean
    AS '$libdir/chkpass', 'chkpass_ne'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ne(chkpass, text) OWNER TO postgres;

--
-- TOC entry 572 (class 1255 OID 17855)
-- Dependencies: 1124 6
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    AS '$libdir/ltree', 'nlevel'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.nlevel(ltree) OWNER TO postgres;

--
-- TOC entry 733 (class 1255 OID 18189)
-- Dependencies: 6
-- Name: normal_rand(integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION normal_rand(integer, double precision, double precision) RETURNS SETOF double precision
    AS '$libdir/tablefunc', 'normal_rand'
    LANGUAGE c STRICT;


ALTER FUNCTION public.normal_rand(integer, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 629 (class 1255 OID 18008)
-- Dependencies: 6
-- Name: page_header(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION page_header(page bytea, OUT lsn text, OUT tli smallint, OUT flags smallint, OUT lower smallint, OUT upper smallint, OUT special smallint, OUT pagesize smallint, OUT version smallint, OUT prune_xid xid) RETURNS record
    AS '$libdir/pageinspect', 'page_header'
    LANGUAGE c STRICT;


ALTER FUNCTION public.page_header(page bytea, OUT lsn text, OUT tli smallint, OUT flags smallint, OUT lower smallint, OUT upper smallint, OUT special smallint, OUT pagesize smallint, OUT version smallint, OUT prune_xid xid) OWNER TO postgres;

--
-- TOC entry 689 (class 1255 OID 18101)
-- Dependencies: 6
-- Name: pg_relpages(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pg_relpages(text) RETURNS integer
    AS '$libdir/pgstattuple', 'pg_relpages'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pg_relpages(text) OWNER TO postgres;

--
-- TOC entry 683 (class 1255 OID 18095)
-- Dependencies: 6
-- Name: pgp_key_id(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_key_id(bytea) RETURNS text
    AS '$libdir/pgcrypto', 'pgp_key_id_w'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_key_id(bytea) OWNER TO postgres;

--
-- TOC entry 677 (class 1255 OID 18089)
-- Dependencies: 6
-- Name: pgp_pub_decrypt(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt(bytea, bytea) RETURNS text
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_pub_decrypt(bytea, bytea) OWNER TO postgres;

--
-- TOC entry 679 (class 1255 OID 18091)
-- Dependencies: 6
-- Name: pgp_pub_decrypt(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt(bytea, bytea, text) RETURNS text
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 681 (class 1255 OID 18093)
-- Dependencies: 6
-- Name: pgp_pub_decrypt(bytea, bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt(bytea, bytea, text, text) RETURNS text
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) OWNER TO postgres;

--
-- TOC entry 678 (class 1255 OID 18090)
-- Dependencies: 6
-- Name: pgp_pub_decrypt_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt_bytea(bytea, bytea) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) OWNER TO postgres;

--
-- TOC entry 680 (class 1255 OID 18092)
-- Dependencies: 6
-- Name: pgp_pub_decrypt_bytea(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 682 (class 1255 OID 18094)
-- Dependencies: 6
-- Name: pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) OWNER TO postgres;

--
-- TOC entry 673 (class 1255 OID 18085)
-- Dependencies: 6
-- Name: pgp_pub_encrypt(text, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt(text, bytea) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_pub_encrypt(text, bytea) OWNER TO postgres;

--
-- TOC entry 675 (class 1255 OID 18087)
-- Dependencies: 6
-- Name: pgp_pub_encrypt(text, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt(text, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_pub_encrypt(text, bytea, text) OWNER TO postgres;

--
-- TOC entry 674 (class 1255 OID 18086)
-- Dependencies: 6
-- Name: pgp_pub_encrypt_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt_bytea(bytea, bytea) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) OWNER TO postgres;

--
-- TOC entry 676 (class 1255 OID 18088)
-- Dependencies: 6
-- Name: pgp_pub_encrypt_bytea(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) OWNER TO postgres;

--
-- TOC entry 669 (class 1255 OID 18081)
-- Dependencies: 6
-- Name: pgp_sym_decrypt(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt(bytea, text) RETURNS text
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_sym_decrypt(bytea, text) OWNER TO postgres;

--
-- TOC entry 671 (class 1255 OID 18083)
-- Dependencies: 6
-- Name: pgp_sym_decrypt(bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt(bytea, text, text) RETURNS text
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_sym_decrypt(bytea, text, text) OWNER TO postgres;

--
-- TOC entry 670 (class 1255 OID 18082)
-- Dependencies: 6
-- Name: pgp_sym_decrypt_bytea(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt_bytea(bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) OWNER TO postgres;

--
-- TOC entry 672 (class 1255 OID 18084)
-- Dependencies: 6
-- Name: pgp_sym_decrypt_bytea(bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt_bytea(bytea, text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) OWNER TO postgres;

--
-- TOC entry 665 (class 1255 OID 18077)
-- Dependencies: 6
-- Name: pgp_sym_encrypt(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt(text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_sym_encrypt(text, text) OWNER TO postgres;

--
-- TOC entry 667 (class 1255 OID 18079)
-- Dependencies: 6
-- Name: pgp_sym_encrypt(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt(text, text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_sym_encrypt(text, text, text) OWNER TO postgres;

--
-- TOC entry 666 (class 1255 OID 18078)
-- Dependencies: 6
-- Name: pgp_sym_encrypt_bytea(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt_bytea(bytea, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) OWNER TO postgres;

--
-- TOC entry 668 (class 1255 OID 18080)
-- Dependencies: 6
-- Name: pgp_sym_encrypt_bytea(bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt_bytea(bytea, text, text) RETURNS bytea
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) OWNER TO postgres;

--
-- TOC entry 688 (class 1255 OID 18100)
-- Dependencies: 6
-- Name: pgstatindex(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgstatindex(relname text, OUT version integer, OUT tree_level integer, OUT index_size integer, OUT root_block_no integer, OUT internal_pages integer, OUT leaf_pages integer, OUT empty_pages integer, OUT deleted_pages integer, OUT avg_leaf_density double precision, OUT leaf_fragmentation double precision) RETURNS record
    AS '$libdir/pgstattuple', 'pgstatindex'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgstatindex(relname text, OUT version integer, OUT tree_level integer, OUT index_size integer, OUT root_block_no integer, OUT internal_pages integer, OUT leaf_pages integer, OUT empty_pages integer, OUT deleted_pages integer, OUT avg_leaf_density double precision, OUT leaf_fragmentation double precision) OWNER TO postgres;

--
-- TOC entry 686 (class 1255 OID 18098)
-- Dependencies: 6
-- Name: pgstattuple(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgstattuple(relname text, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision) RETURNS record
    AS '$libdir/pgstattuple', 'pgstattuple'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgstattuple(relname text, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision) OWNER TO postgres;

--
-- TOC entry 687 (class 1255 OID 18099)
-- Dependencies: 6
-- Name: pgstattuple(oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgstattuple(reloid oid, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision) RETURNS record
    AS '$libdir/pgstattuple', 'pgstattuplebyid'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pgstattuple(reloid oid, OUT table_len bigint, OUT tuple_count bigint, OUT tuple_len bigint, OUT tuple_percent double precision, OUT dead_tuple_count bigint, OUT dead_tuple_len bigint, OUT dead_tuple_percent double precision, OUT free_space bigint, OUT free_percent double precision) OWNER TO postgres;

--
-- TOC entry 769 (class 1255 OID 18249)
-- Dependencies: 6
-- Name: pldbg_abort_target(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_abort_target(session integer) RETURNS SETOF boolean
    AS '$libdir/pldbgapi', 'pldbg_abort_target'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_abort_target(session integer) OWNER TO postgres;

--
-- TOC entry 770 (class 1255 OID 18250)
-- Dependencies: 6
-- Name: pldbg_attach_to_port(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_attach_to_port(portnumber integer) RETURNS integer
    AS '$libdir/pldbgapi', 'pldbg_attach_to_port'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_attach_to_port(portnumber integer) OWNER TO postgres;

--
-- TOC entry 771 (class 1255 OID 18251)
-- Dependencies: 1154 6
-- Name: pldbg_continue(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_continue(session integer) RETURNS breakpoint
    AS '$libdir/pldbgapi', 'pldbg_continue'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_continue(session integer) OWNER TO postgres;

--
-- TOC entry 772 (class 1255 OID 18252)
-- Dependencies: 6
-- Name: pldbg_create_listener(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_create_listener() RETURNS integer
    AS '$libdir/pldbgapi', 'pldbg_create_listener'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_create_listener() OWNER TO postgres;

--
-- TOC entry 773 (class 1255 OID 18253)
-- Dependencies: 6
-- Name: pldbg_deposit_value(integer, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_deposit_value(session integer, varname text, linenumber integer, value text) RETURNS boolean
    AS '$libdir/pldbgapi', 'pldbg_deposit_value'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_deposit_value(session integer, varname text, linenumber integer, value text) OWNER TO postgres;

--
-- TOC entry 774 (class 1255 OID 18254)
-- Dependencies: 6
-- Name: pldbg_drop_breakpoint(integer, oid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_drop_breakpoint(session integer, func oid, linenumber integer) RETURNS boolean
    AS '$libdir/pldbgapi', 'pldbg_drop_breakpoint'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_drop_breakpoint(session integer, func oid, linenumber integer) OWNER TO postgres;

--
-- TOC entry 775 (class 1255 OID 18255)
-- Dependencies: 6 1154
-- Name: pldbg_get_breakpoints(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_breakpoints(session integer) RETURNS SETOF breakpoint
    AS '$libdir/pldbgapi', 'pldbg_get_breakpoints'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_get_breakpoints(session integer) OWNER TO postgres;

--
-- TOC entry 778 (class 1255 OID 18258)
-- Dependencies: 1162 6
-- Name: pldbg_get_proxy_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_proxy_info() RETURNS proxyinfo
    AS '$libdir/pldbgapi', 'pldbg_get_proxy_info'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_get_proxy_info() OWNER TO postgres;

--
-- TOC entry 776 (class 1255 OID 18256)
-- Dependencies: 6
-- Name: pldbg_get_source(integer, oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_source(session integer, func oid) RETURNS text
    AS '$libdir/pldbgapi', 'pldbg_get_source'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_get_source(session integer, func oid) OWNER TO postgres;

--
-- TOC entry 777 (class 1255 OID 18257)
-- Dependencies: 1156 6
-- Name: pldbg_get_stack(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_stack(session integer) RETURNS SETOF frame
    AS '$libdir/pldbgapi', 'pldbg_get_stack'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_get_stack(session integer) OWNER TO postgres;

--
-- TOC entry 787 (class 1255 OID 18267)
-- Dependencies: 1158 6
-- Name: pldbg_get_target_info(text, "char"); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_target_info(signature text, targettype "char") RETURNS targetinfo
    AS '$libdir/targetinfo', 'pldbg_get_target_info'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_get_target_info(signature text, targettype "char") OWNER TO postgres;

--
-- TOC entry 779 (class 1255 OID 18259)
-- Dependencies: 1160 6
-- Name: pldbg_get_variables(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_variables(session integer) RETURNS SETOF var
    AS '$libdir/pldbgapi', 'pldbg_get_variables'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_get_variables(session integer) OWNER TO postgres;

--
-- TOC entry 780 (class 1255 OID 18260)
-- Dependencies: 1154 6
-- Name: pldbg_select_frame(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_select_frame(session integer, frame integer) RETURNS breakpoint
    AS '$libdir/pldbgapi', 'pldbg_select_frame'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_select_frame(session integer, frame integer) OWNER TO postgres;

--
-- TOC entry 781 (class 1255 OID 18261)
-- Dependencies: 6
-- Name: pldbg_set_breakpoint(integer, oid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_set_breakpoint(session integer, func oid, linenumber integer) RETURNS boolean
    AS '$libdir/pldbgapi', 'pldbg_set_breakpoint'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_set_breakpoint(session integer, func oid, linenumber integer) OWNER TO postgres;

--
-- TOC entry 782 (class 1255 OID 18262)
-- Dependencies: 6
-- Name: pldbg_set_global_breakpoint(integer, oid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_set_global_breakpoint(session integer, func oid, linenumber integer, targetpid integer) RETURNS boolean
    AS '$libdir/pldbgapi', 'pldbg_set_global_breakpoint'
    LANGUAGE c;


ALTER FUNCTION public.pldbg_set_global_breakpoint(session integer, func oid, linenumber integer, targetpid integer) OWNER TO postgres;

--
-- TOC entry 783 (class 1255 OID 18263)
-- Dependencies: 6 1154
-- Name: pldbg_step_into(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_step_into(session integer) RETURNS breakpoint
    AS '$libdir/pldbgapi', 'pldbg_step_into'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_step_into(session integer) OWNER TO postgres;

--
-- TOC entry 784 (class 1255 OID 18264)
-- Dependencies: 1154 6
-- Name: pldbg_step_over(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_step_over(session integer) RETURNS breakpoint
    AS '$libdir/pldbgapi', 'pldbg_step_over'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_step_over(session integer) OWNER TO postgres;

--
-- TOC entry 785 (class 1255 OID 18265)
-- Dependencies: 1154 6
-- Name: pldbg_wait_for_breakpoint(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_wait_for_breakpoint(session integer) RETURNS breakpoint
    AS '$libdir/pldbgapi', 'pldbg_wait_for_breakpoint'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_wait_for_breakpoint(session integer) OWNER TO postgres;

--
-- TOC entry 786 (class 1255 OID 18266)
-- Dependencies: 6
-- Name: pldbg_wait_for_target(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_wait_for_target(session integer) RETURNS integer
    AS '$libdir/pldbgapi', 'pldbg_wait_for_target'
    LANGUAGE c STRICT;


ALTER FUNCTION public.pldbg_wait_for_target(session integer) OWNER TO postgres;

--
-- TOC entry 768 (class 1255 OID 18248)
-- Dependencies: 6
-- Name: plpgsql_oid_debug(oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plpgsql_oid_debug(functionoid oid) RETURNS integer
    AS '$libdir/plugins/plugin_debugger', 'plpgsql_oid_debug'
    LANGUAGE c STRICT;


ALTER FUNCTION public.plpgsql_oid_debug(functionoid oid) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 17053)
-- Dependencies: 6 1093
-- Name: querytree(query_int); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION querytree(query_int) RETURNS text
    AS '$libdir/_int', 'querytree'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.querytree(query_int) OWNER TO postgres;

--
-- TOC entry 143 (class 1255 OID 16846)
-- Dependencies: 6 1075
-- Name: raw(chkpass); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION raw(chkpass) RETURNS text
    AS '$libdir/chkpass', 'chkpass_rout'
    LANGUAGE c STRICT;


ALTER FUNCTION public.raw(chkpass) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 17055)
-- Dependencies: 1093 6
-- Name: rboolop(query_int, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rboolop(query_int, integer[]) RETURNS boolean
    AS '$libdir/_int', 'rboolop'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.rboolop(query_int, integer[]) OWNER TO postgres;

--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 270
-- Name: FUNCTION rboolop(query_int, integer[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION rboolop(query_int, integer[]) IS 'boolean operation with array';


--
-- TOC entry 218 (class 1255 OID 16968)
-- Dependencies: 6
-- Name: sec_to_gc(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sec_to_gc(double precision) RETURNS double precision
    AS $_$SELECT CASE WHEN $1 < 0 THEN 0::float8 WHEN $1/(2*earth()) > 1 THEN pi()*earth() ELSE 2*earth()*asin($1/(2*earth())) END$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.sec_to_gc(double precision) OWNER TO postgres;

--
-- TOC entry 705 (class 1255 OID 18119)
-- Dependencies: 1145 6 1145
-- Name: seg_cmp(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_cmp(seg, seg) RETURNS integer
    AS '$libdir/seg', 'seg_cmp'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_cmp(seg, seg) OWNER TO postgres;

--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 705
-- Name: FUNCTION seg_cmp(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_cmp(seg, seg) IS 'btree comparison function';


--
-- TOC entry 701 (class 1255 OID 18115)
-- Dependencies: 6 1145 1145
-- Name: seg_contained(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_contained(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_contained'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_contained(seg, seg) OWNER TO postgres;

--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 701
-- Name: FUNCTION seg_contained(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_contained(seg, seg) IS 'contained in';


--
-- TOC entry 700 (class 1255 OID 18114)
-- Dependencies: 6 1145 1145
-- Name: seg_contains(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_contains(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_contains'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_contains(seg, seg) OWNER TO postgres;

--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 700
-- Name: FUNCTION seg_contains(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_contains(seg, seg) IS 'contains';


--
-- TOC entry 704 (class 1255 OID 18118)
-- Dependencies: 1145 1145 6
-- Name: seg_different(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_different(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_different'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_different(seg, seg) OWNER TO postgres;

--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 704
-- Name: FUNCTION seg_different(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_different(seg, seg) IS 'different';


--
-- TOC entry 699 (class 1255 OID 18113)
-- Dependencies: 6 1145 1145
-- Name: seg_ge(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_ge(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_ge'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_ge(seg, seg) OWNER TO postgres;

--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 699
-- Name: FUNCTION seg_ge(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_ge(seg, seg) IS 'greater than or equal';


--
-- TOC entry 698 (class 1255 OID 18112)
-- Dependencies: 6 1145 1145
-- Name: seg_gt(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_gt(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_gt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_gt(seg, seg) OWNER TO postgres;

--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 698
-- Name: FUNCTION seg_gt(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_gt(seg, seg) IS 'greater than';


--
-- TOC entry 707 (class 1255 OID 18121)
-- Dependencies: 6 1145 1145 1145
-- Name: seg_inter(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_inter(seg, seg) RETURNS seg
    AS '$libdir/seg', 'seg_inter'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_inter(seg, seg) OWNER TO postgres;

--
-- TOC entry 697 (class 1255 OID 18111)
-- Dependencies: 1145 6 1145
-- Name: seg_le(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_le(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_le'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_le(seg, seg) OWNER TO postgres;

--
-- TOC entry 3473 (class 0 OID 0)
-- Dependencies: 697
-- Name: FUNCTION seg_le(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_le(seg, seg) IS 'less than or equal';


--
-- TOC entry 694 (class 1255 OID 18108)
-- Dependencies: 1145 6 1145
-- Name: seg_left(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_left(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_left'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_left(seg, seg) OWNER TO postgres;

--
-- TOC entry 3474 (class 0 OID 0)
-- Dependencies: 694
-- Name: FUNCTION seg_left(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_left(seg, seg) IS 'is left of';


--
-- TOC entry 710 (class 1255 OID 18124)
-- Dependencies: 1145 6
-- Name: seg_lower(seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_lower(seg) RETURNS real
    AS '$libdir/seg', 'seg_lower'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_lower(seg) OWNER TO postgres;

--
-- TOC entry 696 (class 1255 OID 18110)
-- Dependencies: 6 1145 1145
-- Name: seg_lt(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_lt(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_lt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_lt(seg, seg) OWNER TO postgres;

--
-- TOC entry 3475 (class 0 OID 0)
-- Dependencies: 696
-- Name: FUNCTION seg_lt(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_lt(seg, seg) IS 'less than';


--
-- TOC entry 692 (class 1255 OID 18106)
-- Dependencies: 1145 1145 6
-- Name: seg_over_left(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_over_left(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_over_left'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_over_left(seg, seg) OWNER TO postgres;

--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 692
-- Name: FUNCTION seg_over_left(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_over_left(seg, seg) IS 'overlaps or is left of';


--
-- TOC entry 693 (class 1255 OID 18107)
-- Dependencies: 1145 6 1145
-- Name: seg_over_right(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_over_right(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_over_right'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_over_right(seg, seg) OWNER TO postgres;

--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 693
-- Name: FUNCTION seg_over_right(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_over_right(seg, seg) IS 'overlaps or is right of';


--
-- TOC entry 702 (class 1255 OID 18116)
-- Dependencies: 6 1145 1145
-- Name: seg_overlap(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_overlap(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_overlap'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_overlap(seg, seg) OWNER TO postgres;

--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 702
-- Name: FUNCTION seg_overlap(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_overlap(seg, seg) IS 'overlaps';


--
-- TOC entry 695 (class 1255 OID 18109)
-- Dependencies: 1145 1145 6
-- Name: seg_right(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_right(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_right'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_right(seg, seg) OWNER TO postgres;

--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 695
-- Name: FUNCTION seg_right(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_right(seg, seg) IS 'is right of';


--
-- TOC entry 703 (class 1255 OID 18117)
-- Dependencies: 1145 6 1145
-- Name: seg_same(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_same(seg, seg) RETURNS boolean
    AS '$libdir/seg', 'seg_same'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_same(seg, seg) OWNER TO postgres;

--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 703
-- Name: FUNCTION seg_same(seg, seg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION seg_same(seg, seg) IS 'same as';


--
-- TOC entry 708 (class 1255 OID 18122)
-- Dependencies: 1145 6
-- Name: seg_size(seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_size(seg) RETURNS real
    AS '$libdir/seg', 'seg_size'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_size(seg) OWNER TO postgres;

--
-- TOC entry 706 (class 1255 OID 18120)
-- Dependencies: 1145 1145 1145 6
-- Name: seg_union(seg, seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_union(seg, seg) RETURNS seg
    AS '$libdir/seg', 'seg_union'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_union(seg, seg) OWNER TO postgres;

--
-- TOC entry 709 (class 1255 OID 18123)
-- Dependencies: 1145 6
-- Name: seg_upper(seg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION seg_upper(seg) RETURNS real
    AS '$libdir/seg', 'seg_upper'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.seg_upper(seg) OWNER TO postgres;

--
-- TOC entry 636 (class 1255 OID 18028)
-- Dependencies: 6
-- Name: set_limit(real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_limit(real) RETURNS real
    AS '$libdir/pg_trgm', 'set_limit'
    LANGUAGE c STRICT;


ALTER FUNCTION public.set_limit(real) OWNER TO postgres;

--
-- TOC entry 724 (class 1255 OID 18180)
-- Dependencies: 6
-- Name: set_timetravel(name, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_timetravel(name, integer) RETURNS integer
    AS '$libdir/timetravel', 'set_timetravel'
    LANGUAGE c STRICT;


ALTER FUNCTION public.set_timetravel(name, integer) OWNER TO postgres;

--
-- TOC entry 637 (class 1255 OID 18029)
-- Dependencies: 6
-- Name: show_limit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION show_limit() RETURNS real
    AS '$libdir/pg_trgm', 'show_limit'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.show_limit() OWNER TO postgres;

--
-- TOC entry 638 (class 1255 OID 18030)
-- Dependencies: 6
-- Name: show_trgm(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION show_trgm(text) RETURNS text[]
    AS '$libdir/pg_trgm', 'show_trgm'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.show_trgm(text) OWNER TO postgres;

--
-- TOC entry 639 (class 1255 OID 18031)
-- Dependencies: 6
-- Name: similarity(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION similarity(text, text) RETURNS real
    AS '$libdir/pg_trgm', 'similarity'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.similarity(text, text) OWNER TO postgres;

--
-- TOC entry 640 (class 1255 OID 18032)
-- Dependencies: 6
-- Name: similarity_op(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION similarity_op(text, text) RETURNS boolean
    AS '$libdir/pg_trgm', 'similarity_op'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.similarity_op(text, text) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 17008)
-- Dependencies: 6 1087
-- Name: skeys(hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION skeys(hstore) RETURNS SETOF text
    AS '$libdir/hstore', 'skeys'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.skeys(hstore) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 17073)
-- Dependencies: 6
-- Name: sort(integer[], text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sort(integer[], text) RETURNS integer[]
    AS '$libdir/_int', 'sort'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.sort(integer[], text) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 17074)
-- Dependencies: 6
-- Name: sort(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sort(integer[]) RETURNS integer[]
    AS '$libdir/_int', 'sort'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.sort(integer[]) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 17075)
-- Dependencies: 6
-- Name: sort_asc(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sort_asc(integer[]) RETURNS integer[]
    AS '$libdir/_int', 'sort_asc'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.sort_asc(integer[]) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 17076)
-- Dependencies: 6
-- Name: sort_desc(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sort_desc(integer[]) RETURNS integer[]
    AS '$libdir/_int', 'sort_desc'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.sort_desc(integer[]) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16979)
-- Dependencies: 6
-- Name: soundex(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION soundex(text) RETURNS text
    AS '$libdir/fuzzystrmatch', 'soundex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.soundex(text) OWNER TO postgres;

--
-- TOC entry 728 (class 1255 OID 18184)
-- Dependencies: 6
-- Name: ssl_client_cert_present(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_client_cert_present() RETURNS boolean
    AS '$libdir/sslinfo', 'ssl_client_cert_present'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_client_cert_present() OWNER TO postgres;

--
-- TOC entry 731 (class 1255 OID 18187)
-- Dependencies: 6
-- Name: ssl_client_dn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_client_dn() RETURNS text
    AS '$libdir/sslinfo', 'ssl_client_dn'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_client_dn() OWNER TO postgres;

--
-- TOC entry 729 (class 1255 OID 18185)
-- Dependencies: 6
-- Name: ssl_client_dn_field(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_client_dn_field(text) RETURNS text
    AS '$libdir/sslinfo', 'ssl_client_dn_field'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_client_dn_field(text) OWNER TO postgres;

--
-- TOC entry 726 (class 1255 OID 18182)
-- Dependencies: 6
-- Name: ssl_client_serial(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_client_serial() RETURNS numeric
    AS '$libdir/sslinfo', 'ssl_client_serial'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_client_serial() OWNER TO postgres;

--
-- TOC entry 727 (class 1255 OID 18183)
-- Dependencies: 6
-- Name: ssl_is_used(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_is_used() RETURNS boolean
    AS '$libdir/sslinfo', 'ssl_is_used'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_is_used() OWNER TO postgres;

--
-- TOC entry 732 (class 1255 OID 18188)
-- Dependencies: 6
-- Name: ssl_issuer_dn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_issuer_dn() RETURNS text
    AS '$libdir/sslinfo', 'ssl_issuer_dn'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_issuer_dn() OWNER TO postgres;

--
-- TOC entry 730 (class 1255 OID 18186)
-- Dependencies: 6
-- Name: ssl_issuer_field(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ssl_issuer_field(text) RETURNS text
    AS '$libdir/sslinfo', 'ssl_issuer_field'
    LANGUAGE c STRICT;


ALTER FUNCTION public.ssl_issuer_field(text) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 17080)
-- Dependencies: 6
-- Name: subarray(integer[], integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION subarray(integer[], integer, integer) RETURNS integer[]
    AS '$libdir/_int', 'subarray'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.subarray(integer[], integer, integer) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 17081)
-- Dependencies: 6
-- Name: subarray(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION subarray(integer[], integer) RETURNS integer[]
    AS '$libdir/_int', 'subarray'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.subarray(integer[], integer) OWNER TO postgres;

--
-- TOC entry 567 (class 1255 OID 17850)
-- Dependencies: 6 1124 1124
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    AS '$libdir/ltree', 'subltree'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.subltree(ltree, integer, integer) OWNER TO postgres;

--
-- TOC entry 568 (class 1255 OID 17851)
-- Dependencies: 6 1124 1124
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    AS '$libdir/ltree', 'subpath'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.subpath(ltree, integer, integer) OWNER TO postgres;

--
-- TOC entry 569 (class 1255 OID 17852)
-- Dependencies: 6 1124 1124
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    AS '$libdir/ltree', 'subpath'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.subpath(ltree, integer) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 17009)
-- Dependencies: 1087 6
-- Name: svals(hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION svals(hstore) RETURNS SETOF text
    AS '$libdir/hstore', 'svals'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.svals(hstore) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 17004)
-- Dependencies: 6 1087
-- Name: tconvert(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tconvert(text, text) RETURNS hstore
    AS '$libdir/hstore', 'tconvert'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.tconvert(text, text) OWNER TO postgres;

--
-- TOC entry 574 (class 1255 OID 17857)
-- Dependencies: 1124 6
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    AS '$libdir/ltree', 'text2ltree'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.text2ltree(text) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 16980)
-- Dependencies: 6
-- Name: text_soundex(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION text_soundex(text) RETURNS text
    AS '$libdir/fuzzystrmatch', 'soundex'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.text_soundex(text) OWNER TO postgres;

--
-- TOC entry 723 (class 1255 OID 18179)
-- Dependencies: 6
-- Name: timetravel(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION timetravel() RETURNS trigger
    AS '$libdir/timetravel', 'timetravel'
    LANGUAGE c;


ALTER FUNCTION public.timetravel() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 17077)
-- Dependencies: 6
-- Name: uniq(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uniq(integer[]) RETURNS integer[]
    AS '$libdir/_int', 'uniq'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uniq(integer[]) OWNER TO postgres;

--
-- TOC entry 537 (class 1255 OID 17791)
-- Dependencies: 1099 1120 6
-- Name: upc(ean13); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upc(ean13) RETURNS upc
    AS '$libdir/isn', 'upc_cast_from_ean13'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.upc(ean13) OWNER TO postgres;

--
-- TOC entry 749 (class 1255 OID 18214)
-- Dependencies: 6
-- Name: uuid_generate_v1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_generate_v1() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_generate_v1'
    LANGUAGE c STRICT;


ALTER FUNCTION public.uuid_generate_v1() OWNER TO postgres;

--
-- TOC entry 750 (class 1255 OID 18215)
-- Dependencies: 6
-- Name: uuid_generate_v1mc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_generate_v1mc() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
    LANGUAGE c STRICT;


ALTER FUNCTION public.uuid_generate_v1mc() OWNER TO postgres;

--
-- TOC entry 751 (class 1255 OID 18216)
-- Dependencies: 6
-- Name: uuid_generate_v3(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_generate_v3(namespace uuid, name text) RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_generate_v3'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_generate_v3(namespace uuid, name text) OWNER TO postgres;

--
-- TOC entry 752 (class 1255 OID 18217)
-- Dependencies: 6
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_generate_v4() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_generate_v4'
    LANGUAGE c STRICT;


ALTER FUNCTION public.uuid_generate_v4() OWNER TO postgres;

--
-- TOC entry 753 (class 1255 OID 18218)
-- Dependencies: 6
-- Name: uuid_generate_v5(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_generate_v5(namespace uuid, name text) RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_generate_v5'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_generate_v5(namespace uuid, name text) OWNER TO postgres;

--
-- TOC entry 744 (class 1255 OID 18209)
-- Dependencies: 6
-- Name: uuid_nil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_nil() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_nil'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_nil() OWNER TO postgres;

--
-- TOC entry 745 (class 1255 OID 18210)
-- Dependencies: 6
-- Name: uuid_ns_dns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_ns_dns() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_ns_dns'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_ns_dns() OWNER TO postgres;

--
-- TOC entry 747 (class 1255 OID 18212)
-- Dependencies: 6
-- Name: uuid_ns_oid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_ns_oid() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_ns_oid'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_ns_oid() OWNER TO postgres;

--
-- TOC entry 746 (class 1255 OID 18211)
-- Dependencies: 6
-- Name: uuid_ns_url(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_ns_url() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_ns_url'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_ns_url() OWNER TO postgres;

--
-- TOC entry 748 (class 1255 OID 18213)
-- Dependencies: 6
-- Name: uuid_ns_x500(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid_ns_x500() RETURNS uuid
    AS '$libdir/uuid-ossp', 'uuid_ns_x500'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.uuid_ns_x500() OWNER TO postgres;

--
-- TOC entry 756 (class 1255 OID 18221)
-- Dependencies: 6
-- Name: xml_encode_special_chars(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xml_encode_special_chars(text) RETURNS text
    AS '$libdir/pgxml', 'xml_encode_special_chars'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xml_encode_special_chars(text) OWNER TO postgres;

--
-- TOC entry 754 (class 1255 OID 18219)
-- Dependencies: 6
-- Name: xml_is_well_formed(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xml_is_well_formed(text) RETURNS boolean
    AS '$libdir/pgxml', 'xml_is_well_formed'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xml_is_well_formed(text) OWNER TO postgres;

--
-- TOC entry 755 (class 1255 OID 18220)
-- Dependencies: 6
-- Name: xml_valid(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xml_valid(text) RETURNS boolean
    AS '$libdir/pgxml', 'xml_is_well_formed'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xml_valid(text) OWNER TO postgres;

--
-- TOC entry 760 (class 1255 OID 18225)
-- Dependencies: 6
-- Name: xpath_bool(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_bool(text, text) RETURNS boolean
    AS '$libdir/pgxml', 'xpath_bool'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_bool(text, text) OWNER TO postgres;

--
-- TOC entry 761 (class 1255 OID 18226)
-- Dependencies: 6
-- Name: xpath_list(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_list(text, text, text) RETURNS text
    AS '$libdir/pgxml', 'xpath_list'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_list(text, text, text) OWNER TO postgres;

--
-- TOC entry 762 (class 1255 OID 18227)
-- Dependencies: 6
-- Name: xpath_list(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_list(text, text) RETURNS text
    AS $_$SELECT xpath_list($1,$2,',')$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_list(text, text) OWNER TO postgres;

--
-- TOC entry 758 (class 1255 OID 18223)
-- Dependencies: 6
-- Name: xpath_nodeset(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_nodeset(text, text, text, text) RETURNS text
    AS '$libdir/pgxml', 'xpath_nodeset'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_nodeset(text, text, text, text) OWNER TO postgres;

--
-- TOC entry 763 (class 1255 OID 18228)
-- Dependencies: 6
-- Name: xpath_nodeset(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_nodeset(text, text) RETURNS text
    AS $_$SELECT xpath_nodeset($1,$2,'','')$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_nodeset(text, text) OWNER TO postgres;

--
-- TOC entry 764 (class 1255 OID 18229)
-- Dependencies: 6
-- Name: xpath_nodeset(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_nodeset(text, text, text) RETURNS text
    AS $_$SELECT xpath_nodeset($1,$2,'',$3)$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_nodeset(text, text, text) OWNER TO postgres;

--
-- TOC entry 759 (class 1255 OID 18224)
-- Dependencies: 6
-- Name: xpath_number(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_number(text, text) RETURNS real
    AS '$libdir/pgxml', 'xpath_number'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_number(text, text) OWNER TO postgres;

--
-- TOC entry 757 (class 1255 OID 18222)
-- Dependencies: 6
-- Name: xpath_string(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_string(text, text) RETURNS text
    AS '$libdir/pgxml', 'xpath_string'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xpath_string(text, text) OWNER TO postgres;

--
-- TOC entry 765 (class 1255 OID 18230)
-- Dependencies: 6
-- Name: xpath_table(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_table(text, text, text, text, text) RETURNS SETOF record
    AS '$libdir/pgxml', 'xpath_table'
    LANGUAGE c STABLE STRICT;


ALTER FUNCTION public.xpath_table(text, text, text, text, text) OWNER TO postgres;

--
-- TOC entry 766 (class 1255 OID 18231)
-- Dependencies: 6
-- Name: xslt_process(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xslt_process(text, text, text) RETURNS text
    AS '$libdir/pgxml', 'xslt_process'
    LANGUAGE c STRICT;


ALTER FUNCTION public.xslt_process(text, text, text) OWNER TO postgres;

--
-- TOC entry 767 (class 1255 OID 18232)
-- Dependencies: 6
-- Name: xslt_process(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xslt_process(text, text) RETURNS text
    AS '$libdir/pgxml', 'xslt_process'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.xslt_process(text, text) OWNER TO postgres;

--
-- TOC entry 1295 (class 1255 OID 17047)
-- Dependencies: 264 6 263
-- Name: int_array_aggregate(integer); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE int_array_aggregate(integer) (
    SFUNC = int_agg_state,
    STYPE = integer[],
    FINALFUNC = int_agg_final_array
);


ALTER AGGREGATE public.int_array_aggregate(integer) OWNER TO postgres;

--
-- TOC entry 2032 (class 2617 OID 17072)
-- Dependencies: 6 279
-- Name: #; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR # (
    PROCEDURE = icount,
    RIGHTARG = integer[]
);


ALTER OPERATOR public.# (NONE, integer[]) OWNER TO postgres;

--
-- TOC entry 2033 (class 2617 OID 17079)
-- Dependencies: 6 285
-- Name: #; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR # (
    PROCEDURE = idx,
    LEFTARG = integer[],
    RIGHTARG = integer
);


ALTER OPERATOR public.# (integer[], integer) OWNER TO postgres;

--
-- TOC entry 2253 (class 2617 OID 18033)
-- Dependencies: 6 640
-- Name: %; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR % (
    PROCEDURE = similarity_op,
    LEFTARG = text,
    RIGHTARG = text,
    COMMUTATOR = %,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.% (text, text) OWNER TO postgres;

--
-- TOC entry 2018 (class 2617 OID 17093)
-- Dependencies: 6 277
-- Name: &; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR & (
    PROCEDURE = _int_inter,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = &
);


ALTER OPERATOR public.& (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2004 (class 2617 OID 16885)
-- Dependencies: 1078 6 159 1078
-- Name: &&; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR && (
    PROCEDURE = cube_overlap,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = &&,
    RESTRICT = areasel,
    JOIN = areajoinsel
);


ALTER OPERATOR public.&& (cube, cube) OWNER TO postgres;

--
-- TOC entry 2026 (class 2617 OID 17065)
-- Dependencies: 273 6
-- Name: &&; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR && (
    PROCEDURE = _int_overlap,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = &&,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.&& (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2260 (class 2617 OID 18132)
-- Dependencies: 1145 6 1145 702
-- Name: &&; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR && (
    PROCEDURE = seg_overlap,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = &&,
    RESTRICT = areasel,
    JOIN = areajoinsel
);


ALTER OPERATOR public.&& (seg, seg) OWNER TO postgres;

--
-- TOC entry 2259 (class 2617 OID 18131)
-- Dependencies: 6 1145 1145 692
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = seg_over_left,
    LEFTARG = seg,
    RIGHTARG = seg,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&< (seg, seg) OWNER TO postgres;

--
-- TOC entry 2261 (class 2617 OID 18133)
-- Dependencies: 6 1145 693 1145
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = seg_over_right,
    LEFTARG = seg,
    RIGHTARG = seg,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&> (seg, seg) OWNER TO postgres;

--
-- TOC entry 2034 (class 2617 OID 17083)
-- Dependencies: 6 288
-- Name: +; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR + (
    PROCEDURE = intarray_push_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


ALTER OPERATOR public.+ (integer[], integer) OWNER TO postgres;

--
-- TOC entry 2035 (class 2617 OID 17085)
-- Dependencies: 289 6
-- Name: +; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR + (
    PROCEDURE = intarray_push_array,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = +
);


ALTER OPERATOR public.+ (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2036 (class 2617 OID 17087)
-- Dependencies: 6 290
-- Name: -; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR - (
    PROCEDURE = intarray_del_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


ALTER OPERATOR public.- (integer[], integer) OWNER TO postgres;

--
-- TOC entry 2009 (class 2617 OID 17092)
-- Dependencies: 6 292
-- Name: -; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR - (
    PROCEDURE = intset_subtract,
    LEFTARG = integer[],
    RIGHTARG = integer[]
);


ALTER OPERATOR public.- (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2014 (class 2617 OID 16989)
-- Dependencies: 6 236 1087
-- Name: ->; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR -> (
    PROCEDURE = fetchval,
    LEFTARG = hstore,
    RIGHTARG = text
);


ALTER OPERATOR public.-> (hstore, text) OWNER TO postgres;

--
-- TOC entry 2000 (class 2617 OID 16883)
-- Dependencies: 6 152 1078 1078
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = cube_lt,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (cube, cube) OWNER TO postgres;

--
-- TOC entry 2038 (class 2617 OID 17361)
-- Dependencies: 1099 1099 327 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, ean13) OWNER TO postgres;

--
-- TOC entry 2042 (class 2617 OID 17367)
-- Dependencies: 1102 1099 333 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = isbn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 2048 (class 2617 OID 17375)
-- Dependencies: 1099 6 1102 387
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = isbn13,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 2054 (class 2617 OID 17379)
-- Dependencies: 6 339 1105 1099
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = ismn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 2060 (class 2617 OID 17387)
-- Dependencies: 1099 423 1105 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ismn13,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 2066 (class 2617 OID 17391)
-- Dependencies: 1108 1099 6 345
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = issn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, issn13) OWNER TO postgres;

--
-- TOC entry 2168 (class 2617 OID 17399)
-- Dependencies: 1108 459 1099 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = issn13,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (issn13, ean13) OWNER TO postgres;

--
-- TOC entry 2072 (class 2617 OID 17403)
-- Dependencies: 351 6 1099 1111
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = isbn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, isbn) OWNER TO postgres;

--
-- TOC entry 2120 (class 2617 OID 17411)
-- Dependencies: 6 1099 1111 405
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = isbn,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (isbn, ean13) OWNER TO postgres;

--
-- TOC entry 2078 (class 2617 OID 17415)
-- Dependencies: 6 1099 1114 357
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = ismn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, ismn) OWNER TO postgres;

--
-- TOC entry 2150 (class 2617 OID 17423)
-- Dependencies: 6 1114 1099 441
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ismn,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ismn, ean13) OWNER TO postgres;

--
-- TOC entry 2084 (class 2617 OID 17427)
-- Dependencies: 6 363 1117 1099
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = issn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, issn) OWNER TO postgres;

--
-- TOC entry 2186 (class 2617 OID 17435)
-- Dependencies: 6 477 1099 1117
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = issn,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (issn, ean13) OWNER TO postgres;

--
-- TOC entry 2090 (class 2617 OID 17439)
-- Dependencies: 369 1120 1099 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ean13,
    RIGHTARG = upc,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ean13, upc) OWNER TO postgres;

--
-- TOC entry 2201 (class 2617 OID 17447)
-- Dependencies: 1120 489 1099 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = upc,
    RIGHTARG = ean13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (upc, ean13) OWNER TO postgres;

--
-- TOC entry 2096 (class 2617 OID 17451)
-- Dependencies: 1102 6 375 1102
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = isbn13,
    RIGHTARG = isbn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 2102 (class 2617 OID 17457)
-- Dependencies: 1102 381 1111 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = isbn13,
    RIGHTARG = isbn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 2114 (class 2617 OID 17465)
-- Dependencies: 6 399 1102 1111
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = isbn,
    RIGHTARG = isbn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 2108 (class 2617 OID 17469)
-- Dependencies: 393 6 1111 1111
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = isbn,
    RIGHTARG = isbn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (isbn, isbn) OWNER TO postgres;

--
-- TOC entry 2126 (class 2617 OID 17475)
-- Dependencies: 1105 6 1105 411
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ismn13,
    RIGHTARG = ismn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 2132 (class 2617 OID 17481)
-- Dependencies: 417 6 1105 1114
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ismn13,
    RIGHTARG = ismn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 2144 (class 2617 OID 17489)
-- Dependencies: 6 435 1114 1105
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ismn,
    RIGHTARG = ismn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 2138 (class 2617 OID 17493)
-- Dependencies: 1114 429 1114 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = ismn,
    RIGHTARG = ismn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (ismn, ismn) OWNER TO postgres;

--
-- TOC entry 2156 (class 2617 OID 17499)
-- Dependencies: 1108 447 1108 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = issn13,
    RIGHTARG = issn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (issn13, issn13) OWNER TO postgres;

--
-- TOC entry 2162 (class 2617 OID 17505)
-- Dependencies: 6 1108 453 1117
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = issn13,
    RIGHTARG = issn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (issn13, issn) OWNER TO postgres;

--
-- TOC entry 2180 (class 2617 OID 17513)
-- Dependencies: 1117 471 1108 6
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = issn,
    RIGHTARG = issn13,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (issn, issn13) OWNER TO postgres;

--
-- TOC entry 2174 (class 2617 OID 17517)
-- Dependencies: 1117 465 6 1117
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = issn,
    RIGHTARG = issn,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (issn, issn) OWNER TO postgres;

--
-- TOC entry 2192 (class 2617 OID 17523)
-- Dependencies: 1120 6 1120 483
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = isnlt,
    LEFTARG = upc,
    RIGHTARG = upc,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (upc, upc) OWNER TO postgres;

--
-- TOC entry 2207 (class 2617 OID 17846)
-- Dependencies: 1124 1124 6 561
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = ltree_lt,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.< (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2254 (class 2617 OID 18127)
-- Dependencies: 1145 6 696 1145
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = seg_lt,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (seg, seg) OWNER TO postgres;

--
-- TOC entry 2258 (class 2617 OID 18130)
-- Dependencies: 1145 1145 694 6
-- Name: <<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR << (
    PROCEDURE = seg_left,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = >>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.<< (seg, seg) OWNER TO postgres;

--
-- TOC entry 2002 (class 2617 OID 16884)
-- Dependencies: 6 154 1078 1078
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = cube_le,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (cube, cube) OWNER TO postgres;

--
-- TOC entry 2039 (class 2617 OID 17362)
-- Dependencies: 1099 1099 328 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, ean13) OWNER TO postgres;

--
-- TOC entry 2043 (class 2617 OID 17370)
-- Dependencies: 334 6 1099 1102
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = isbn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 2049 (class 2617 OID 17374)
-- Dependencies: 6 1102 1099 388
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = isbn13,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 2055 (class 2617 OID 17382)
-- Dependencies: 1099 1105 6 340
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = ismn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 2061 (class 2617 OID 17386)
-- Dependencies: 424 1099 1105 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ismn13,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 2067 (class 2617 OID 17394)
-- Dependencies: 346 1108 6 1099
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = issn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, issn13) OWNER TO postgres;

--
-- TOC entry 2169 (class 2617 OID 17398)
-- Dependencies: 1108 460 1099 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = issn13,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (issn13, ean13) OWNER TO postgres;

--
-- TOC entry 2073 (class 2617 OID 17406)
-- Dependencies: 352 1099 6 1111
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = isbn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, isbn) OWNER TO postgres;

--
-- TOC entry 2121 (class 2617 OID 17410)
-- Dependencies: 6 1111 1099 406
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = isbn,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (isbn, ean13) OWNER TO postgres;

--
-- TOC entry 2079 (class 2617 OID 17418)
-- Dependencies: 1114 358 1099 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = ismn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, ismn) OWNER TO postgres;

--
-- TOC entry 2151 (class 2617 OID 17422)
-- Dependencies: 6 1099 442 1114
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ismn,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ismn, ean13) OWNER TO postgres;

--
-- TOC entry 2085 (class 2617 OID 17430)
-- Dependencies: 1099 6 364 1117
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = issn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, issn) OWNER TO postgres;

--
-- TOC entry 2187 (class 2617 OID 17434)
-- Dependencies: 1117 478 1099 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = issn,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (issn, ean13) OWNER TO postgres;

--
-- TOC entry 2091 (class 2617 OID 17442)
-- Dependencies: 370 1120 1099 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ean13,
    RIGHTARG = upc,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ean13, upc) OWNER TO postgres;

--
-- TOC entry 2202 (class 2617 OID 17446)
-- Dependencies: 1099 1120 6 490
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = upc,
    RIGHTARG = ean13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (upc, ean13) OWNER TO postgres;

--
-- TOC entry 2097 (class 2617 OID 17452)
-- Dependencies: 6 376 1102 1102
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = isbn13,
    RIGHTARG = isbn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 2103 (class 2617 OID 17460)
-- Dependencies: 382 6 1102 1111
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = isbn13,
    RIGHTARG = isbn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 2115 (class 2617 OID 17464)
-- Dependencies: 1111 6 1102 400
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = isbn,
    RIGHTARG = isbn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 2109 (class 2617 OID 17470)
-- Dependencies: 1111 1111 394 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = isbn,
    RIGHTARG = isbn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (isbn, isbn) OWNER TO postgres;

--
-- TOC entry 2127 (class 2617 OID 17476)
-- Dependencies: 6 412 1105 1105
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ismn13,
    RIGHTARG = ismn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 2133 (class 2617 OID 17484)
-- Dependencies: 1114 1105 6 418
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ismn13,
    RIGHTARG = ismn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 2145 (class 2617 OID 17488)
-- Dependencies: 1114 6 1105 436
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ismn,
    RIGHTARG = ismn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 2139 (class 2617 OID 17494)
-- Dependencies: 1114 430 6 1114
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = ismn,
    RIGHTARG = ismn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (ismn, ismn) OWNER TO postgres;

--
-- TOC entry 2157 (class 2617 OID 17500)
-- Dependencies: 1108 1108 448 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = issn13,
    RIGHTARG = issn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (issn13, issn13) OWNER TO postgres;

--
-- TOC entry 2163 (class 2617 OID 17508)
-- Dependencies: 1108 6 1117 454
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = issn13,
    RIGHTARG = issn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (issn13, issn) OWNER TO postgres;

--
-- TOC entry 2181 (class 2617 OID 17512)
-- Dependencies: 472 6 1117 1108
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = issn,
    RIGHTARG = issn13,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (issn, issn13) OWNER TO postgres;

--
-- TOC entry 2175 (class 2617 OID 17518)
-- Dependencies: 1117 466 1117 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = issn,
    RIGHTARG = issn,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (issn, issn) OWNER TO postgres;

--
-- TOC entry 2195 (class 2617 OID 17524)
-- Dependencies: 484 1120 6 1120
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = isnle,
    LEFTARG = upc,
    RIGHTARG = upc,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (upc, upc) OWNER TO postgres;

--
-- TOC entry 2208 (class 2617 OID 17847)
-- Dependencies: 6 1124 1124 562
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = ltree_le,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<= (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2255 (class 2617 OID 18128)
-- Dependencies: 1145 1145 697 6
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = seg_le,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (seg, seg) OWNER TO postgres;

--
-- TOC entry 1999 (class 2617 OID 16849)
-- Dependencies: 145 1075 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = ne,
    LEFTARG = chkpass,
    RIGHTARG = text,
    NEGATOR = =
);


ALTER OPERATOR public.<> (chkpass, text) OWNER TO postgres;

--
-- TOC entry 2007 (class 2617 OID 16886)
-- Dependencies: 1078 6 151 1078
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = cube_ne,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (cube, cube) OWNER TO postgres;

--
-- TOC entry 2041 (class 2617 OID 17363)
-- Dependencies: 1099 6 1099 332
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, ean13) OWNER TO postgres;

--
-- TOC entry 2047 (class 2617 OID 17372)
-- Dependencies: 1102 6 1099 338
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = isbn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 2053 (class 2617 OID 17376)
-- Dependencies: 1099 392 1102 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = isbn13,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 2059 (class 2617 OID 17384)
-- Dependencies: 1099 6 344 1105
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = ismn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 2065 (class 2617 OID 17388)
-- Dependencies: 1105 1099 428 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ismn13,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 2071 (class 2617 OID 17396)
-- Dependencies: 1108 6 350 1099
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = issn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, issn13) OWNER TO postgres;

--
-- TOC entry 2173 (class 2617 OID 17400)
-- Dependencies: 1099 6 1108 464
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = issn13,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (issn13, ean13) OWNER TO postgres;

--
-- TOC entry 2077 (class 2617 OID 17408)
-- Dependencies: 356 1111 1099 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = isbn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, isbn) OWNER TO postgres;

--
-- TOC entry 2125 (class 2617 OID 17412)
-- Dependencies: 410 1099 6 1111
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = isbn,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (isbn, ean13) OWNER TO postgres;

--
-- TOC entry 2083 (class 2617 OID 17420)
-- Dependencies: 1114 362 1099 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = ismn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, ismn) OWNER TO postgres;

--
-- TOC entry 2155 (class 2617 OID 17424)
-- Dependencies: 446 1099 1114 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ismn,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ismn, ean13) OWNER TO postgres;

--
-- TOC entry 2089 (class 2617 OID 17432)
-- Dependencies: 1099 6 1117 368
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = issn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, issn) OWNER TO postgres;

--
-- TOC entry 2191 (class 2617 OID 17436)
-- Dependencies: 1099 482 6 1117
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = issn,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (issn, ean13) OWNER TO postgres;

--
-- TOC entry 2095 (class 2617 OID 17444)
-- Dependencies: 1099 1120 374 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ean13,
    RIGHTARG = upc,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ean13, upc) OWNER TO postgres;

--
-- TOC entry 2206 (class 2617 OID 17448)
-- Dependencies: 6 1120 494 1099
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = upc,
    RIGHTARG = ean13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (upc, ean13) OWNER TO postgres;

--
-- TOC entry 2101 (class 2617 OID 17453)
-- Dependencies: 6 380 1102 1102
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = isbn13,
    RIGHTARG = isbn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 2107 (class 2617 OID 17462)
-- Dependencies: 386 1111 1102 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = isbn13,
    RIGHTARG = isbn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 2119 (class 2617 OID 17466)
-- Dependencies: 1102 1111 404 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = isbn,
    RIGHTARG = isbn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 2113 (class 2617 OID 17471)
-- Dependencies: 398 1111 1111 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = isbn,
    RIGHTARG = isbn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (isbn, isbn) OWNER TO postgres;

--
-- TOC entry 2131 (class 2617 OID 17477)
-- Dependencies: 6 1105 1105 416
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ismn13,
    RIGHTARG = ismn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 2137 (class 2617 OID 17486)
-- Dependencies: 6 422 1114 1105
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ismn13,
    RIGHTARG = ismn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 2149 (class 2617 OID 17490)
-- Dependencies: 1114 6 1105 440
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ismn,
    RIGHTARG = ismn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 2143 (class 2617 OID 17495)
-- Dependencies: 1114 434 1114 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = ismn,
    RIGHTARG = ismn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ismn, ismn) OWNER TO postgres;

--
-- TOC entry 2161 (class 2617 OID 17501)
-- Dependencies: 452 1108 1108 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = issn13,
    RIGHTARG = issn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (issn13, issn13) OWNER TO postgres;

--
-- TOC entry 2167 (class 2617 OID 17510)
-- Dependencies: 458 1108 1117 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = issn13,
    RIGHTARG = issn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (issn13, issn) OWNER TO postgres;

--
-- TOC entry 2185 (class 2617 OID 17514)
-- Dependencies: 476 1108 1117 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = issn,
    RIGHTARG = issn13,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (issn, issn13) OWNER TO postgres;

--
-- TOC entry 2179 (class 2617 OID 17519)
-- Dependencies: 6 470 1117 1117
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = issn,
    RIGHTARG = issn,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (issn, issn) OWNER TO postgres;

--
-- TOC entry 2200 (class 2617 OID 17525)
-- Dependencies: 488 1120 1120 6
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = isnne,
    LEFTARG = upc,
    RIGHTARG = upc,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (upc, upc) OWNER TO postgres;

--
-- TOC entry 2209 (class 2617 OID 17848)
-- Dependencies: 6 1124 1124 566
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = ltree_ne,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2264 (class 2617 OID 18134)
-- Dependencies: 1145 704 6 1145
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = seg_different,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (seg, seg) OWNER TO postgres;

--
-- TOC entry 2010 (class 2617 OID 16888)
-- Dependencies: 1078 158 1078 6
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = cube_contained,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (cube, cube) OWNER TO postgres;

--
-- TOC entry 2019 (class 2617 OID 17000)
-- Dependencies: 1087 244 6 1087
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = hs_contained,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (hstore, hstore) OWNER TO postgres;

--
-- TOC entry 2028 (class 2617 OID 17066)
-- Dependencies: 272 6
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = _int_contained,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2212 (class 2617 OID 17872)
-- Dependencies: 1124 588 6 584 1124
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = ltree_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = @>,
    RESTRICT = ltreeparentsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2230 (class 2617 OID 17956)
-- Dependencies: 1124 1126 609 6
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = _ltree_r_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (ltree, ltree[]) OWNER TO postgres;

--
-- TOC entry 2231 (class 2617 OID 17959)
-- Dependencies: 6 1126 1124 610
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = _ltree_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 2266 (class 2617 OID 18136)
-- Dependencies: 6 1145 1145 701
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = seg_contained,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (seg, seg) OWNER TO postgres;

--
-- TOC entry 2013 (class 2617 OID 16976)
-- Dependencies: 226 6
-- Name: <@>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@> (
    PROCEDURE = geo_distance,
    LEFTARG = point,
    RIGHTARG = point,
    COMMUTATOR = <@>
);


ALTER OPERATOR public.<@> (point, point) OWNER TO postgres;

--
-- TOC entry 1998 (class 2617 OID 16850)
-- Dependencies: 144 1075 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = eq,
    LEFTARG = chkpass,
    RIGHTARG = text,
    NEGATOR = <>
);


ALTER OPERATOR public.= (chkpass, text) OWNER TO postgres;

--
-- TOC entry 2005 (class 2617 OID 16887)
-- Dependencies: 150 1078 1078 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = cube_eq,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (cube, cube) OWNER TO postgres;

--
-- TOC entry 2024 (class 2617 OID 17364)
-- Dependencies: 6 1099 1099 329
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, ean13) OWNER TO postgres;

--
-- TOC entry 2050 (class 2617 OID 17371)
-- Dependencies: 6 389 1099 1102
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = isbn13,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 2044 (class 2617 OID 17373)
-- Dependencies: 1099 335 6 1102
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = isbn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 2062 (class 2617 OID 17383)
-- Dependencies: 1099 1105 6 425
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ismn13,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 2056 (class 2617 OID 17385)
-- Dependencies: 1099 1105 341 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = ismn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 2170 (class 2617 OID 17395)
-- Dependencies: 1108 1099 6 461
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = issn13,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (issn13, ean13) OWNER TO postgres;

--
-- TOC entry 2068 (class 2617 OID 17397)
-- Dependencies: 347 1108 6 1099
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = issn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, issn13) OWNER TO postgres;

--
-- TOC entry 2122 (class 2617 OID 17407)
-- Dependencies: 6 407 1099 1111
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = isbn,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (isbn, ean13) OWNER TO postgres;

--
-- TOC entry 2074 (class 2617 OID 17409)
-- Dependencies: 6 1111 353 1099
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = isbn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, isbn) OWNER TO postgres;

--
-- TOC entry 2152 (class 2617 OID 17419)
-- Dependencies: 1114 6 443 1099
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ismn,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ismn, ean13) OWNER TO postgres;

--
-- TOC entry 2080 (class 2617 OID 17421)
-- Dependencies: 359 6 1114 1099
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = ismn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, ismn) OWNER TO postgres;

--
-- TOC entry 2188 (class 2617 OID 17431)
-- Dependencies: 1117 479 1099 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = issn,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (issn, ean13) OWNER TO postgres;

--
-- TOC entry 2086 (class 2617 OID 17433)
-- Dependencies: 6 1099 1117 365
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = issn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, issn) OWNER TO postgres;

--
-- TOC entry 2203 (class 2617 OID 17443)
-- Dependencies: 6 491 1099 1120
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = upc,
    RIGHTARG = ean13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (upc, ean13) OWNER TO postgres;

--
-- TOC entry 2092 (class 2617 OID 17445)
-- Dependencies: 6 1099 1120 371
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ean13,
    RIGHTARG = upc,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ean13, upc) OWNER TO postgres;

--
-- TOC entry 2098 (class 2617 OID 17454)
-- Dependencies: 6 1102 377 1102
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = isbn13,
    RIGHTARG = isbn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 2116 (class 2617 OID 17461)
-- Dependencies: 6 1111 1102 401
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = isbn,
    RIGHTARG = isbn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 2104 (class 2617 OID 17463)
-- Dependencies: 1111 6 1102 383
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = isbn13,
    RIGHTARG = isbn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 2110 (class 2617 OID 17472)
-- Dependencies: 395 1111 6 1111
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = isbn,
    RIGHTARG = isbn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (isbn, isbn) OWNER TO postgres;

--
-- TOC entry 2128 (class 2617 OID 17478)
-- Dependencies: 6 413 1105 1105
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ismn13,
    RIGHTARG = ismn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 2146 (class 2617 OID 17485)
-- Dependencies: 437 6 1114 1105
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ismn,
    RIGHTARG = ismn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 2134 (class 2617 OID 17487)
-- Dependencies: 419 1105 6 1114
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ismn13,
    RIGHTARG = ismn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 2140 (class 2617 OID 17496)
-- Dependencies: 431 1114 6 1114
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = ismn,
    RIGHTARG = ismn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ismn, ismn) OWNER TO postgres;

--
-- TOC entry 2158 (class 2617 OID 17502)
-- Dependencies: 449 1108 1108 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = issn13,
    RIGHTARG = issn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (issn13, issn13) OWNER TO postgres;

--
-- TOC entry 2182 (class 2617 OID 17509)
-- Dependencies: 1117 6 473 1108
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = issn,
    RIGHTARG = issn13,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (issn, issn13) OWNER TO postgres;

--
-- TOC entry 2164 (class 2617 OID 17511)
-- Dependencies: 1117 6 1108 455
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = issn13,
    RIGHTARG = issn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (issn13, issn) OWNER TO postgres;

--
-- TOC entry 2176 (class 2617 OID 17520)
-- Dependencies: 1117 6 1117 467
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = issn,
    RIGHTARG = issn,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (issn, issn) OWNER TO postgres;

--
-- TOC entry 2196 (class 2617 OID 17526)
-- Dependencies: 1120 1120 485 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = isneq,
    LEFTARG = upc,
    RIGHTARG = upc,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    HASHES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (upc, upc) OWNER TO postgres;

--
-- TOC entry 2197 (class 2617 OID 17849)
-- Dependencies: 563 6 1124 1124
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = ltree_eq,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2263 (class 2617 OID 18135)
-- Dependencies: 1145 1145 703 6
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = seg_same,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (seg, seg) OWNER TO postgres;

--
-- TOC entry 2022 (class 2617 OID 17005)
-- Dependencies: 6 1087 245
-- Name: =>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR => (
    PROCEDURE = tconvert,
    LEFTARG = text,
    RIGHTARG = text
);


ALTER OPERATOR public.=> (text, text) OWNER TO postgres;

--
-- TOC entry 2001 (class 2617 OID 16881)
-- Dependencies: 1078 153 6 1078
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = cube_gt,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (cube, cube) OWNER TO postgres;

--
-- TOC entry 2040 (class 2617 OID 17359)
-- Dependencies: 1099 1099 6 331
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, ean13) OWNER TO postgres;

--
-- TOC entry 2052 (class 2617 OID 17365)
-- Dependencies: 6 1099 391 1102
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = isbn13,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 2046 (class 2617 OID 17369)
-- Dependencies: 1102 337 6 1099
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = isbn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 2064 (class 2617 OID 17377)
-- Dependencies: 1105 427 6 1099
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ismn13,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 2058 (class 2617 OID 17381)
-- Dependencies: 6 1099 343 1105
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = ismn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 2172 (class 2617 OID 17389)
-- Dependencies: 6 1099 1108 463
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = issn13,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (issn13, ean13) OWNER TO postgres;

--
-- TOC entry 2070 (class 2617 OID 17393)
-- Dependencies: 349 1108 1099 6
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = issn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, issn13) OWNER TO postgres;

--
-- TOC entry 2124 (class 2617 OID 17401)
-- Dependencies: 409 1111 1099 6
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = isbn,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (isbn, ean13) OWNER TO postgres;

--
-- TOC entry 2076 (class 2617 OID 17405)
-- Dependencies: 355 6 1099 1111
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = isbn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, isbn) OWNER TO postgres;

--
-- TOC entry 2154 (class 2617 OID 17413)
-- Dependencies: 445 1099 6 1114
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ismn,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ismn, ean13) OWNER TO postgres;

--
-- TOC entry 2082 (class 2617 OID 17417)
-- Dependencies: 6 361 1114 1099
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = ismn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, ismn) OWNER TO postgres;

--
-- TOC entry 2190 (class 2617 OID 17425)
-- Dependencies: 6 1117 481 1099
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = issn,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (issn, ean13) OWNER TO postgres;

--
-- TOC entry 2088 (class 2617 OID 17429)
-- Dependencies: 1117 1099 6 367
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = issn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, issn) OWNER TO postgres;

--
-- TOC entry 2205 (class 2617 OID 17437)
-- Dependencies: 6 1099 1120 493
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = upc,
    RIGHTARG = ean13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (upc, ean13) OWNER TO postgres;

--
-- TOC entry 2094 (class 2617 OID 17441)
-- Dependencies: 373 6 1120 1099
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ean13,
    RIGHTARG = upc,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ean13, upc) OWNER TO postgres;

--
-- TOC entry 2100 (class 2617 OID 17449)
-- Dependencies: 1102 1102 6 379
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = isbn13,
    RIGHTARG = isbn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 2118 (class 2617 OID 17455)
-- Dependencies: 1102 1111 6 403
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = isbn,
    RIGHTARG = isbn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 2106 (class 2617 OID 17459)
-- Dependencies: 1111 6 1102 385
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = isbn13,
    RIGHTARG = isbn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 2112 (class 2617 OID 17467)
-- Dependencies: 1111 1111 6 397
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = isbn,
    RIGHTARG = isbn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (isbn, isbn) OWNER TO postgres;

--
-- TOC entry 2130 (class 2617 OID 17473)
-- Dependencies: 1105 415 1105 6
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ismn13,
    RIGHTARG = ismn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 2148 (class 2617 OID 17479)
-- Dependencies: 1105 439 6 1114
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ismn,
    RIGHTARG = ismn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 2136 (class 2617 OID 17483)
-- Dependencies: 1114 421 1105 6
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ismn13,
    RIGHTARG = ismn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 2142 (class 2617 OID 17491)
-- Dependencies: 6 1114 1114 433
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = ismn,
    RIGHTARG = ismn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (ismn, ismn) OWNER TO postgres;

--
-- TOC entry 2160 (class 2617 OID 17497)
-- Dependencies: 451 1108 1108 6
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = issn13,
    RIGHTARG = issn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (issn13, issn13) OWNER TO postgres;

--
-- TOC entry 2184 (class 2617 OID 17503)
-- Dependencies: 6 475 1108 1117
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = issn,
    RIGHTARG = issn13,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (issn, issn13) OWNER TO postgres;

--
-- TOC entry 2166 (class 2617 OID 17507)
-- Dependencies: 457 6 1108 1117
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = issn13,
    RIGHTARG = issn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (issn13, issn) OWNER TO postgres;

--
-- TOC entry 2178 (class 2617 OID 17515)
-- Dependencies: 1117 6 1117 469
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = issn,
    RIGHTARG = issn,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (issn, issn) OWNER TO postgres;

--
-- TOC entry 2199 (class 2617 OID 17521)
-- Dependencies: 6 487 1120 1120
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = isngt,
    LEFTARG = upc,
    RIGHTARG = upc,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (upc, upc) OWNER TO postgres;

--
-- TOC entry 2194 (class 2617 OID 17844)
-- Dependencies: 1124 6 1124 565
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = ltree_gt,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.> (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2256 (class 2617 OID 18125)
-- Dependencies: 1145 1145 698 6
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = seg_gt,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (seg, seg) OWNER TO postgres;

--
-- TOC entry 2003 (class 2617 OID 16882)
-- Dependencies: 1078 6 155 1078
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = cube_ge,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (cube, cube) OWNER TO postgres;

--
-- TOC entry 2030 (class 2617 OID 17360)
-- Dependencies: 1099 330 1099 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, ean13) OWNER TO postgres;

--
-- TOC entry 2045 (class 2617 OID 17366)
-- Dependencies: 336 1102 1099 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = isbn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, isbn13) OWNER TO postgres;

--
-- TOC entry 2051 (class 2617 OID 17368)
-- Dependencies: 6 1102 1099 390
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = isbn13,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (isbn13, ean13) OWNER TO postgres;

--
-- TOC entry 2057 (class 2617 OID 17378)
-- Dependencies: 1099 342 1105 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = ismn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, ismn13) OWNER TO postgres;

--
-- TOC entry 2063 (class 2617 OID 17380)
-- Dependencies: 1105 6 1099 426
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ismn13,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ismn13, ean13) OWNER TO postgres;

--
-- TOC entry 2069 (class 2617 OID 17390)
-- Dependencies: 1108 6 1099 348
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = issn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, issn13) OWNER TO postgres;

--
-- TOC entry 2171 (class 2617 OID 17392)
-- Dependencies: 1108 462 6 1099
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = issn13,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (issn13, ean13) OWNER TO postgres;

--
-- TOC entry 2075 (class 2617 OID 17402)
-- Dependencies: 6 1099 1111 354
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = isbn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, isbn) OWNER TO postgres;

--
-- TOC entry 2123 (class 2617 OID 17404)
-- Dependencies: 1099 6 408 1111
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = isbn,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (isbn, ean13) OWNER TO postgres;

--
-- TOC entry 2081 (class 2617 OID 17414)
-- Dependencies: 1114 360 6 1099
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = ismn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, ismn) OWNER TO postgres;

--
-- TOC entry 2153 (class 2617 OID 17416)
-- Dependencies: 1099 444 6 1114
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ismn,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ismn, ean13) OWNER TO postgres;

--
-- TOC entry 2087 (class 2617 OID 17426)
-- Dependencies: 6 1117 1099 366
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = issn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, issn) OWNER TO postgres;

--
-- TOC entry 2189 (class 2617 OID 17428)
-- Dependencies: 6 1099 480 1117
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = issn,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (issn, ean13) OWNER TO postgres;

--
-- TOC entry 2093 (class 2617 OID 17438)
-- Dependencies: 1120 372 1099 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ean13,
    RIGHTARG = upc,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ean13, upc) OWNER TO postgres;

--
-- TOC entry 2204 (class 2617 OID 17440)
-- Dependencies: 1099 1120 6 492
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = upc,
    RIGHTARG = ean13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (upc, ean13) OWNER TO postgres;

--
-- TOC entry 2099 (class 2617 OID 17450)
-- Dependencies: 6 1102 1102 378
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = isbn13,
    RIGHTARG = isbn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (isbn13, isbn13) OWNER TO postgres;

--
-- TOC entry 2105 (class 2617 OID 17456)
-- Dependencies: 384 1111 1102 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = isbn13,
    RIGHTARG = isbn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (isbn13, isbn) OWNER TO postgres;

--
-- TOC entry 2117 (class 2617 OID 17458)
-- Dependencies: 402 6 1102 1111
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = isbn,
    RIGHTARG = isbn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (isbn, isbn13) OWNER TO postgres;

--
-- TOC entry 2111 (class 2617 OID 17468)
-- Dependencies: 6 396 1111 1111
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = isbn,
    RIGHTARG = isbn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (isbn, isbn) OWNER TO postgres;

--
-- TOC entry 2129 (class 2617 OID 17474)
-- Dependencies: 414 1105 1105 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ismn13,
    RIGHTARG = ismn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ismn13, ismn13) OWNER TO postgres;

--
-- TOC entry 2135 (class 2617 OID 17480)
-- Dependencies: 1105 6 420 1114
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ismn13,
    RIGHTARG = ismn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ismn13, ismn) OWNER TO postgres;

--
-- TOC entry 2147 (class 2617 OID 17482)
-- Dependencies: 6 1114 1105 438
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ismn,
    RIGHTARG = ismn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ismn, ismn13) OWNER TO postgres;

--
-- TOC entry 2141 (class 2617 OID 17492)
-- Dependencies: 6 1114 1114 432
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = ismn,
    RIGHTARG = ismn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (ismn, ismn) OWNER TO postgres;

--
-- TOC entry 2159 (class 2617 OID 17498)
-- Dependencies: 6 1108 1108 450
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = issn13,
    RIGHTARG = issn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (issn13, issn13) OWNER TO postgres;

--
-- TOC entry 2165 (class 2617 OID 17504)
-- Dependencies: 1108 456 6 1117
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = issn13,
    RIGHTARG = issn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (issn13, issn) OWNER TO postgres;

--
-- TOC entry 2183 (class 2617 OID 17506)
-- Dependencies: 1117 6 1108 474
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = issn,
    RIGHTARG = issn13,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (issn, issn13) OWNER TO postgres;

--
-- TOC entry 2177 (class 2617 OID 17516)
-- Dependencies: 468 6 1117 1117
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = issn,
    RIGHTARG = issn,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (issn, issn) OWNER TO postgres;

--
-- TOC entry 2198 (class 2617 OID 17522)
-- Dependencies: 1120 486 1120 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = isnge,
    LEFTARG = upc,
    RIGHTARG = upc,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (upc, upc) OWNER TO postgres;

--
-- TOC entry 2193 (class 2617 OID 17845)
-- Dependencies: 564 1124 1124 6
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = ltree_ge,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.>= (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2257 (class 2617 OID 18126)
-- Dependencies: 6 699 1145 1145
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = seg_ge,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (seg, seg) OWNER TO postgres;

--
-- TOC entry 2262 (class 2617 OID 18129)
-- Dependencies: 6 1145 695 1145
-- Name: >>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >> (
    PROCEDURE = seg_right,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = <<,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.>> (seg, seg) OWNER TO postgres;

--
-- TOC entry 2015 (class 2617 OID 16992)
-- Dependencies: 238 1087 6
-- Name: ?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ? (
    PROCEDURE = exist,
    LEFTARG = hstore,
    RIGHTARG = text,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (hstore, text) OWNER TO postgres;

--
-- TOC entry 2222 (class 2617 OID 17899)
-- Dependencies: 1124 1129 594 6
-- Name: ?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ? (
    PROCEDURE = lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree,
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (lquery[], ltree) OWNER TO postgres;

--
-- TOC entry 2221 (class 2617 OID 17900)
-- Dependencies: 6 593 1129 1124
-- Name: ?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ? (
    PROCEDURE = lt_q_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (ltree, lquery[]) OWNER TO postgres;

--
-- TOC entry 2236 (class 2617 OID 17962)
-- Dependencies: 6 1126 615 1129
-- Name: ?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ? (
    PROCEDURE = _lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (lquery[], ltree[]) OWNER TO postgres;

--
-- TOC entry 2235 (class 2617 OID 17963)
-- Dependencies: 6 614 1129 1126
-- Name: ?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ? (
    PROCEDURE = _lt_q_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (ltree[], lquery[]) OWNER TO postgres;

--
-- TOC entry 2250 (class 2617 OID 17979)
-- Dependencies: 1124 619 6 1126 1124
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


ALTER OPERATOR public.?<@ (ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 2252 (class 2617 OID 17983)
-- Dependencies: 621 1124 1126 6 1130
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


ALTER OPERATOR public.?@ (ltree[], ltxtquery) OWNER TO postgres;

--
-- TOC entry 2249 (class 2617 OID 17977)
-- Dependencies: 1124 618 6 1126 1124
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


ALTER OPERATOR public.?@> (ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 2251 (class 2617 OID 17981)
-- Dependencies: 1126 6 1127 1124 620
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


ALTER OPERATOR public.?~ (ltree[], lquery) OWNER TO postgres;

--
-- TOC entry 2011 (class 2617 OID 16891)
-- Dependencies: 1078 157 1078 6
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = cube_contains,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (cube, cube) OWNER TO postgres;

--
-- TOC entry 2020 (class 2617 OID 17003)
-- Dependencies: 6 1087 1087 243
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = hs_contains,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (hstore, hstore) OWNER TO postgres;

--
-- TOC entry 2029 (class 2617 OID 17069)
-- Dependencies: 271 6
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = _int_contains,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2226 (class 2617 OID 17909)
-- Dependencies: 1130 1124 598 6
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltxtquery, ltree) OWNER TO postgres;

--
-- TOC entry 2225 (class 2617 OID 17910)
-- Dependencies: 1124 6 597 1130
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = ltxtq_exec,
    LEFTARG = ltree,
    RIGHTARG = ltxtquery,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltree, ltxtquery) OWNER TO postgres;

--
-- TOC entry 2238 (class 2617 OID 17964)
-- Dependencies: 1126 6 617 1130
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = _ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree[],
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltxtquery, ltree[]) OWNER TO postgres;

--
-- TOC entry 2237 (class 2617 OID 17965)
-- Dependencies: 1130 1126 6 616
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = _ltxtq_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltree[], ltxtquery) OWNER TO postgres;

--
-- TOC entry 2267 (class 2617 OID 18139)
-- Dependencies: 6 700 1145 1145
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = seg_contains,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (seg, seg) OWNER TO postgres;

--
-- TOC entry 2008 (class 2617 OID 16889)
-- Dependencies: 1078 157 6 1078
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = cube_contains,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (cube, cube) OWNER TO postgres;

--
-- TOC entry 2017 (class 2617 OID 17001)
-- Dependencies: 6 1087 1087 243
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = hs_contains,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (hstore, hstore) OWNER TO postgres;

--
-- TOC entry 2027 (class 2617 OID 17067)
-- Dependencies: 271 6
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = _int_contains,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2210 (class 2617 OID 17873)
-- Dependencies: 588 6 1124 1124 583
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = ltree_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <@,
    RESTRICT = ltreeparentsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2229 (class 2617 OID 17957)
-- Dependencies: 1124 6 1126 608
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = _ltree_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 2232 (class 2617 OID 17958)
-- Dependencies: 611 6 1124 1126
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = _ltree_r_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (ltree, ltree[]) OWNER TO postgres;

--
-- TOC entry 2265 (class 2617 OID 18137)
-- Dependencies: 700 6 1145 1145
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = seg_contains,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (seg, seg) OWNER TO postgres;

--
-- TOC entry 2023 (class 2617 OID 17057)
-- Dependencies: 269 1093 6
-- Name: @@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @@ (
    PROCEDURE = boolop,
    LEFTARG = integer[],
    RIGHTARG = query_int,
    COMMUTATOR = ~~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@@ (integer[], query_int) OWNER TO postgres;

--
-- TOC entry 2213 (class 2617 OID 17874)
-- Dependencies: 1124 6 1124 584
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^<@ (
    PROCEDURE = ltree_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^<@ (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2240 (class 2617 OID 17966)
-- Dependencies: 1124 6 609 1126
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^<@ (
    PROCEDURE = _ltree_r_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^<@ (ltree, ltree[]) OWNER TO postgres;

--
-- TOC entry 2241 (class 2617 OID 17969)
-- Dependencies: 6 610 1124 1126
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^<@ (
    PROCEDURE = _ltree_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^<@ (ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 2224 (class 2617 OID 17901)
-- Dependencies: 6 1129 1124 594
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^? (
    PROCEDURE = lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree,
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (lquery[], ltree) OWNER TO postgres;

--
-- TOC entry 2223 (class 2617 OID 17902)
-- Dependencies: 6 1124 1129 593
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^? (
    PROCEDURE = lt_q_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (ltree, lquery[]) OWNER TO postgres;

--
-- TOC entry 2246 (class 2617 OID 17972)
-- Dependencies: 1129 615 1126 6
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^? (
    PROCEDURE = _lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (lquery[], ltree[]) OWNER TO postgres;

--
-- TOC entry 2245 (class 2617 OID 17973)
-- Dependencies: 1129 614 6 1126
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^? (
    PROCEDURE = _lt_q_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (ltree[], lquery[]) OWNER TO postgres;

--
-- TOC entry 2228 (class 2617 OID 17911)
-- Dependencies: 1124 598 6 1130
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@ (
    PROCEDURE = ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltxtquery, ltree) OWNER TO postgres;

--
-- TOC entry 2227 (class 2617 OID 17912)
-- Dependencies: 1124 6 597 1130
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@ (
    PROCEDURE = ltxtq_exec,
    LEFTARG = ltree,
    RIGHTARG = ltxtquery,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltree, ltxtquery) OWNER TO postgres;

--
-- TOC entry 2248 (class 2617 OID 17974)
-- Dependencies: 6 1130 1126 617
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@ (
    PROCEDURE = _ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltxtquery, ltree[]) OWNER TO postgres;

--
-- TOC entry 2247 (class 2617 OID 17975)
-- Dependencies: 1126 616 1130 6
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@ (
    PROCEDURE = _ltxtq_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltree[], ltxtquery) OWNER TO postgres;

--
-- TOC entry 2211 (class 2617 OID 17875)
-- Dependencies: 6 583 1124 1124
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@> (
    PROCEDURE = ltree_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@> (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2239 (class 2617 OID 17967)
-- Dependencies: 1126 6 608 1124
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@> (
    PROCEDURE = _ltree_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@> (ltree[], ltree) OWNER TO postgres;

--
-- TOC entry 2242 (class 2617 OID 17968)
-- Dependencies: 6 611 1124 1126
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^@> (
    PROCEDURE = _ltree_r_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@> (ltree, ltree[]) OWNER TO postgres;

--
-- TOC entry 2220 (class 2617 OID 17895)
-- Dependencies: 1124 6 1127 592
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^~ (
    PROCEDURE = ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (lquery, ltree) OWNER TO postgres;

--
-- TOC entry 2219 (class 2617 OID 17896)
-- Dependencies: 591 6 1124 1127
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^~ (
    PROCEDURE = ltq_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (ltree, lquery) OWNER TO postgres;

--
-- TOC entry 2244 (class 2617 OID 17970)
-- Dependencies: 1126 6 613 1127
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^~ (
    PROCEDURE = _ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (lquery, ltree[]) OWNER TO postgres;

--
-- TOC entry 2243 (class 2617 OID 17971)
-- Dependencies: 1127 6 1126 612
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ^~ (
    PROCEDURE = _ltq_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (ltree[], lquery) OWNER TO postgres;

--
-- TOC entry 2037 (class 2617 OID 17089)
-- Dependencies: 291 6
-- Name: |; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR | (
    PROCEDURE = intset_union_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


ALTER OPERATOR public.| (integer[], integer) OWNER TO postgres;

--
-- TOC entry 2006 (class 2617 OID 17090)
-- Dependencies: 276 6
-- Name: |; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR | (
    PROCEDURE = _int_union,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = |
);


ALTER OPERATOR public.| (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2016 (class 2617 OID 16997)
-- Dependencies: 6 1087 242 1087 1087
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = hs_concat,
    LEFTARG = hstore,
    RIGHTARG = hstore
);


ALTER OPERATOR public.|| (hstore, hstore) OWNER TO postgres;

--
-- TOC entry 2214 (class 2617 OID 17876)
-- Dependencies: 585 6 1124 1124 1124
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


ALTER OPERATOR public.|| (ltree, ltree) OWNER TO postgres;

--
-- TOC entry 2215 (class 2617 OID 17877)
-- Dependencies: 1124 6 1124 586
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


ALTER OPERATOR public.|| (ltree, text) OWNER TO postgres;

--
-- TOC entry 2216 (class 2617 OID 17878)
-- Dependencies: 1124 6 1124 587
-- Name: ||; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


ALTER OPERATOR public.|| (text, ltree) OWNER TO postgres;

--
-- TOC entry 2012 (class 2617 OID 16890)
-- Dependencies: 1078 1078 158 6
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = cube_contained,
    LEFTARG = cube,
    RIGHTARG = cube,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (cube, cube) OWNER TO postgres;

--
-- TOC entry 2021 (class 2617 OID 17002)
-- Dependencies: 244 6 1087 1087
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = hs_contained,
    LEFTARG = hstore,
    RIGHTARG = hstore,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (hstore, hstore) OWNER TO postgres;

--
-- TOC entry 2031 (class 2617 OID 17068)
-- Dependencies: 272 6
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = _int_contained,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (integer[], integer[]) OWNER TO postgres;

--
-- TOC entry 2218 (class 2617 OID 17893)
-- Dependencies: 1124 6 1127 592
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (lquery, ltree) OWNER TO postgres;

--
-- TOC entry 2217 (class 2617 OID 17894)
-- Dependencies: 591 6 1124 1127
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = ltq_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (ltree, lquery) OWNER TO postgres;

--
-- TOC entry 2234 (class 2617 OID 17960)
-- Dependencies: 613 1126 1127 6
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = _ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (lquery, ltree[]) OWNER TO postgres;

--
-- TOC entry 2233 (class 2617 OID 17961)
-- Dependencies: 6 612 1127 1126
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = _ltq_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (ltree[], lquery) OWNER TO postgres;

--
-- TOC entry 2268 (class 2617 OID 18138)
-- Dependencies: 1145 6 701 1145
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = seg_contained,
    LEFTARG = seg,
    RIGHTARG = seg,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (seg, seg) OWNER TO postgres;

--
-- TOC entry 2025 (class 2617 OID 17056)
-- Dependencies: 6 270 1093
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~~ (
    PROCEDURE = rboolop,
    LEFTARG = query_int,
    RIGHTARG = integer[],
    COMMUTATOR = @@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~~ (query_int, integer[]) OWNER TO postgres;

--
-- TOC entry 2403 (class 2616 OID 16900)
-- Dependencies: 6 1078 2562
-- Name: cube_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS cube_ops
    DEFAULT FOR TYPE cube USING btree AS
    OPERATOR 1 <(cube,cube) ,
    OPERATOR 2 <=(cube,cube) ,
    OPERATOR 3 =(cube,cube) ,
    OPERATOR 4 >=(cube,cube) ,
    OPERATOR 5 >(cube,cube) ,
    FUNCTION 1 cube_cmp(cube,cube);


ALTER OPERATOR CLASS public.cube_ops USING btree OWNER TO postgres;

--
-- TOC entry 2569 (class 2753 OID 17527)
-- Dependencies: 6
-- Name: isn_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY isn_ops USING btree;
ALTER OPERATOR FAMILY isn_ops USING btree ADD
    OPERATOR 1 <(ismn,ean13) ,
    OPERATOR 1 <(ismn13,ismn) ,
    OPERATOR 1 <(ismn13,ean13) ,
    OPERATOR 1 <(isbn,isbn13) ,
    OPERATOR 1 <(isbn,ean13) ,
    OPERATOR 1 <(isbn13,isbn) ,
    OPERATOR 1 <(isbn13,ean13) ,
    OPERATOR 1 <(ean13,ismn13) ,
    OPERATOR 1 <(ean13,issn13) ,
    OPERATOR 1 <(ean13,isbn) ,
    OPERATOR 1 <(ean13,ismn) ,
    OPERATOR 1 <(ean13,issn) ,
    OPERATOR 1 <(ean13,isbn13) ,
    OPERATOR 1 <(ean13,upc) ,
    OPERATOR 1 <(upc,ean13) ,
    OPERATOR 1 <(issn,issn13) ,
    OPERATOR 1 <(issn,ean13) ,
    OPERATOR 1 <(issn13,issn) ,
    OPERATOR 1 <(issn13,ean13) ,
    OPERATOR 1 <(ismn,ismn13) ,
    OPERATOR 2 <=(ean13,issn) ,
    OPERATOR 2 <=(ean13,isbn13) ,
    OPERATOR 2 <=(ean13,ismn13) ,
    OPERATOR 2 <=(ean13,issn13) ,
    OPERATOR 2 <=(ean13,isbn) ,
    OPERATOR 2 <=(ean13,ismn) ,
    OPERATOR 2 <=(ean13,upc) ,
    OPERATOR 2 <=(isbn13,ean13) ,
    OPERATOR 2 <=(isbn13,isbn) ,
    OPERATOR 2 <=(isbn,ean13) ,
    OPERATOR 2 <=(isbn,isbn13) ,
    OPERATOR 2 <=(ismn13,ean13) ,
    OPERATOR 2 <=(ismn13,ismn) ,
    OPERATOR 2 <=(ismn,ean13) ,
    OPERATOR 2 <=(ismn,ismn13) ,
    OPERATOR 2 <=(issn13,ean13) ,
    OPERATOR 2 <=(issn13,issn) ,
    OPERATOR 2 <=(issn,ean13) ,
    OPERATOR 2 <=(issn,issn13) ,
    OPERATOR 2 <=(upc,ean13) ,
    OPERATOR 3 =(ean13,issn13) ,
    OPERATOR 3 =(issn,ean13) ,
    OPERATOR 3 =(issn,issn13) ,
    OPERATOR 3 =(isbn,ean13) ,
    OPERATOR 3 =(isbn,isbn13) ,
    OPERATOR 3 =(ismn13,ean13) ,
    OPERATOR 3 =(ismn13,ismn) ,
    OPERATOR 3 =(ean13,upc) ,
    OPERATOR 3 =(ean13,issn) ,
    OPERATOR 3 =(ismn,ean13) ,
    OPERATOR 3 =(ismn,ismn13) ,
    OPERATOR 3 =(ean13,ismn) ,
    OPERATOR 3 =(ean13,isbn) ,
    OPERATOR 3 =(ean13,isbn13) ,
    OPERATOR 3 =(issn13,ean13) ,
    OPERATOR 3 =(issn13,issn) ,
    OPERATOR 3 =(isbn13,isbn) ,
    OPERATOR 3 =(ean13,ismn13) ,
    OPERATOR 3 =(upc,ean13) ,
    OPERATOR 3 =(isbn13,ean13) ,
    OPERATOR 4 >=(ean13,ismn) ,
    OPERATOR 4 >=(ismn13,ean13) ,
    OPERATOR 4 >=(ismn13,ismn) ,
    OPERATOR 4 >=(ean13,upc) ,
    OPERATOR 4 >=(ismn,ean13) ,
    OPERATOR 4 >=(ismn,ismn13) ,
    OPERATOR 4 >=(ean13,issn) ,
    OPERATOR 4 >=(isbn13,ean13) ,
    OPERATOR 4 >=(isbn13,isbn) ,
    OPERATOR 4 >=(ean13,isbn) ,
    OPERATOR 4 >=(ean13,issn13) ,
    OPERATOR 4 >=(issn13,ean13) ,
    OPERATOR 4 >=(issn13,issn) ,
    OPERATOR 4 >=(isbn,ean13) ,
    OPERATOR 4 >=(isbn,isbn13) ,
    OPERATOR 4 >=(ean13,ismn13) ,
    OPERATOR 4 >=(ean13,isbn13) ,
    OPERATOR 4 >=(issn,ean13) ,
    OPERATOR 4 >=(issn,issn13) ,
    OPERATOR 4 >=(upc,ean13) ,
    OPERATOR 5 >(issn13,issn) ,
    OPERATOR 5 >(isbn,ean13) ,
    OPERATOR 5 >(isbn,isbn13) ,
    OPERATOR 5 >(ismn13,ean13) ,
    OPERATOR 5 >(ismn13,ismn) ,
    OPERATOR 5 >(isbn13,ean13) ,
    OPERATOR 5 >(ean13,isbn13) ,
    OPERATOR 5 >(issn,ean13) ,
    OPERATOR 5 >(issn,issn13) ,
    OPERATOR 5 >(ean13,ismn13) ,
    OPERATOR 5 >(ean13,issn13) ,
    OPERATOR 5 >(isbn13,isbn) ,
    OPERATOR 5 >(issn13,ean13) ,
    OPERATOR 5 >(ismn,ean13) ,
    OPERATOR 5 >(ismn,ismn13) ,
    OPERATOR 5 >(ean13,isbn) ,
    OPERATOR 5 >(ean13,ismn) ,
    OPERATOR 5 >(ean13,issn) ,
    OPERATOR 5 >(upc,ean13) ,
    OPERATOR 5 >(ean13,upc) ,
    FUNCTION 1 (ean13, isbn13) btean13cmp(ean13,isbn13) ,
    FUNCTION 1 (ean13, ismn13) btean13cmp(ean13,ismn13) ,
    FUNCTION 1 (ean13, issn13) btean13cmp(ean13,issn13) ,
    FUNCTION 1 (ean13, isbn) btean13cmp(ean13,isbn) ,
    FUNCTION 1 (ean13, ismn) btean13cmp(ean13,ismn) ,
    FUNCTION 1 (ean13, issn) btean13cmp(ean13,issn) ,
    FUNCTION 1 (ean13, upc) btean13cmp(ean13,upc) ,
    FUNCTION 1 (isbn13, ean13) btisbn13cmp(isbn13,ean13) ,
    FUNCTION 1 (isbn13, isbn) btisbn13cmp(isbn13,isbn) ,
    FUNCTION 1 (isbn, ean13) btisbncmp(isbn,ean13) ,
    FUNCTION 1 (isbn, isbn13) btisbncmp(isbn,isbn13) ,
    FUNCTION 1 (ismn13, ean13) btismn13cmp(ismn13,ean13) ,
    FUNCTION 1 (ismn13, ismn) btismn13cmp(ismn13,ismn) ,
    FUNCTION 1 (ismn, ean13) btismncmp(ismn,ean13) ,
    FUNCTION 1 (ismn, ismn13) btismncmp(ismn,ismn13) ,
    FUNCTION 1 (issn13, ean13) btissn13cmp(issn13,ean13) ,
    FUNCTION 1 (issn13, issn) btissn13cmp(issn13,issn) ,
    FUNCTION 1 (issn, ean13) btissncmp(issn,ean13) ,
    FUNCTION 1 (issn, issn13) btissncmp(issn,issn13) ,
    FUNCTION 1 (upc, ean13) btupccmp(upc,ean13);


ALTER OPERATOR FAMILY public.isn_ops USING btree OWNER TO postgres;

--
-- TOC entry 2410 (class 2616 OID 17530)
-- Dependencies: 2569 6 1099
-- Name: ean13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ean13_ops
    DEFAULT FOR TYPE ean13 USING btree FAMILY isn_ops AS
    OPERATOR 1 <(ean13,ean13) ,
    OPERATOR 2 <=(ean13,ean13) ,
    OPERATOR 3 =(ean13,ean13) ,
    OPERATOR 4 >=(ean13,ean13) ,
    OPERATOR 5 >(ean13,ean13) ,
    FUNCTION 1 btean13cmp(ean13,ean13);


ALTER OPERATOR CLASS public.ean13_ops USING btree OWNER TO postgres;

--
-- TOC entry 2570 (class 2753 OID 17528)
-- Dependencies: 6
-- Name: isn_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY isn_ops USING hash;
ALTER OPERATOR FAMILY isn_ops USING hash ADD
    OPERATOR 1 =(upc,ean13) ,
    OPERATOR 1 =(issn,issn13) ,
    OPERATOR 1 =(issn,ean13) ,
    OPERATOR 1 =(issn13,issn) ,
    OPERATOR 1 =(issn13,ean13) ,
    OPERATOR 1 =(ismn,ismn13) ,
    OPERATOR 1 =(ismn,ean13) ,
    OPERATOR 1 =(ismn13,ismn) ,
    OPERATOR 1 =(ismn13,ean13) ,
    OPERATOR 1 =(isbn,isbn13) ,
    OPERATOR 1 =(isbn,ean13) ,
    OPERATOR 1 =(isbn13,isbn) ,
    OPERATOR 1 =(isbn13,ean13) ,
    OPERATOR 1 =(ean13,upc) ,
    OPERATOR 1 =(ean13,issn) ,
    OPERATOR 1 =(ean13,ismn) ,
    OPERATOR 1 =(ean13,isbn) ,
    OPERATOR 1 =(ean13,issn13) ,
    OPERATOR 1 =(ean13,ismn13) ,
    OPERATOR 1 =(ean13,isbn13);


ALTER OPERATOR FAMILY public.isn_ops USING hash OWNER TO postgres;

--
-- TOC entry 2411 (class 2616 OID 17538)
-- Dependencies: 6 2570 1099
-- Name: ean13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ean13_ops
    DEFAULT FOR TYPE ean13 USING hash FAMILY isn_ops AS
    OPERATOR 1 =(ean13,ean13) ,
    FUNCTION 1 hashean13(ean13);


ALTER OPERATOR CLASS public.ean13_ops USING hash OWNER TO postgres;

--
-- TOC entry 2409 (class 2616 OID 17147)
-- Dependencies: 2568 6
-- Name: gin__int_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gin__int_ops
    FOR TYPE integer[] USING gin AS
    STORAGE integer ,
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) RECHECK ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) RECHECK ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) RECHECK ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 btint4cmp(integer,integer) ,
    FUNCTION 2 ginarrayextract(anyarray,internal) ,
    FUNCTION 3 ginint4_queryextract(internal,internal,smallint) ,
    FUNCTION 4 ginint4_consistent(internal,smallint,internal);


ALTER OPERATOR CLASS public.gin__int_ops USING gin OWNER TO postgres;

--
-- TOC entry 2406 (class 2616 OID 17038)
-- Dependencies: 6 2565 1087
-- Name: gin_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gin_hstore_ops
    DEFAULT FOR TYPE hstore USING gin AS
    STORAGE text ,
    OPERATOR 7 @>(hstore,hstore) RECHECK ,
    OPERATOR 9 ?(hstore,text) ,
    FUNCTION 1 bttextcmp(text,text) ,
    FUNCTION 2 gin_extract_hstore(internal,internal) ,
    FUNCTION 3 gin_extract_hstore_query(internal,internal,smallint) ,
    FUNCTION 4 gin_consistent_hstore(internal,smallint,internal);


ALTER OPERATOR CLASS public.gin_hstore_ops USING gin OWNER TO postgres;

--
-- TOC entry 2430 (class 2616 OID 18059)
-- Dependencies: 6 2575
-- Name: gin_trgm_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gin_trgm_ops
    FOR TYPE text USING gin AS
    STORAGE integer ,
    OPERATOR 1 %(text,text) RECHECK ,
    FUNCTION 1 btint4cmp(integer,integer) ,
    FUNCTION 2 gin_extract_trgm(text,internal) ,
    FUNCTION 3 gin_extract_trgm(text,internal,internal) ,
    FUNCTION 4 gin_trgm_consistent(internal,internal,text);


ALTER OPERATOR CLASS public.gin_trgm_ops USING gin OWNER TO postgres;

--
-- TOC entry 2407 (class 2616 OID 17102)
-- Dependencies: 2566 6
-- Name: gist__int_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist__int_ops
    DEFAULT FOR TYPE integer[] USING gist AS
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) RECHECK ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 g_int_consistent(internal,integer[],integer) ,
    FUNCTION 2 g_int_union(internal,internal) ,
    FUNCTION 3 g_int_compress(internal) ,
    FUNCTION 4 g_int_decompress(internal) ,
    FUNCTION 5 g_int_penalty(internal,internal,internal) ,
    FUNCTION 6 g_int_picksplit(internal,internal) ,
    FUNCTION 7 g_int_same(integer[],integer[],internal);


ALTER OPERATOR CLASS public.gist__int_ops USING gist OWNER TO postgres;

--
-- TOC entry 2408 (class 2616 OID 17129)
-- Dependencies: 1096 2567 6
-- Name: gist__intbig_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist__intbig_ops
    FOR TYPE integer[] USING gist AS
    STORAGE intbig_gkey ,
    OPERATOR 3 &&(integer[],integer[]) RECHECK ,
    OPERATOR 6 =(anyarray,anyarray) RECHECK ,
    OPERATOR 7 @>(integer[],integer[]) RECHECK ,
    OPERATOR 8 <@(integer[],integer[]) RECHECK ,
    OPERATOR 13 @(integer[],integer[]) RECHECK ,
    OPERATOR 14 ~(integer[],integer[]) RECHECK ,
    OPERATOR 20 @@(integer[],query_int) RECHECK ,
    FUNCTION 1 g_intbig_consistent(internal,internal,integer) ,
    FUNCTION 2 g_intbig_union(internal,internal) ,
    FUNCTION 3 g_intbig_compress(internal) ,
    FUNCTION 4 g_intbig_decompress(internal) ,
    FUNCTION 5 g_intbig_penalty(internal,internal,internal) ,
    FUNCTION 6 g_intbig_picksplit(internal,internal) ,
    FUNCTION 7 g_intbig_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist__intbig_ops USING gist OWNER TO postgres;

--
-- TOC entry 2428 (class 2616 OID 17991)
-- Dependencies: 2573 6 1133 1126
-- Name: gist__ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist__ltree_ops
    DEFAULT FOR TYPE ltree[] USING gist AS
    STORAGE ltree_gist ,
    OPERATOR 10 <@(ltree[],ltree) RECHECK ,
    OPERATOR 11 @>(ltree,ltree[]) RECHECK ,
    OPERATOR 12 ~(ltree[],lquery) RECHECK ,
    OPERATOR 13 ~(lquery,ltree[]) RECHECK ,
    OPERATOR 14 @(ltree[],ltxtquery) RECHECK ,
    OPERATOR 15 @(ltxtquery,ltree[]) RECHECK ,
    OPERATOR 16 ?(ltree[],lquery[]) RECHECK ,
    OPERATOR 17 ?(lquery[],ltree[]) RECHECK ,
    FUNCTION 1 _ltree_consistent(internal,internal,smallint) ,
    FUNCTION 2 _ltree_union(internal,internal) ,
    FUNCTION 3 _ltree_compress(internal) ,
    FUNCTION 4 ltree_decompress(internal) ,
    FUNCTION 5 _ltree_penalty(internal,internal,internal) ,
    FUNCTION 6 _ltree_picksplit(internal,internal) ,
    FUNCTION 7 _ltree_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist__ltree_ops USING gist OWNER TO postgres;

--
-- TOC entry 2399 (class 2616 OID 16781)
-- Dependencies: 1072 2558 6
-- Name: gist_bit_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_bit_ops
    DEFAULT FOR TYPE bit USING gist AS
    STORAGE gbtreekey_var ,
    OPERATOR 1 <(bit,bit) ,
    OPERATOR 2 <=(bit,bit) ,
    OPERATOR 3 =(bit,bit) ,
    OPERATOR 4 >=(bit,bit) ,
    OPERATOR 5 >(bit,bit) ,
    FUNCTION 1 gbt_bit_consistent(internal,bit,smallint) ,
    FUNCTION 2 gbt_bit_union(bytea,internal) ,
    FUNCTION 3 gbt_bit_compress(internal) ,
    FUNCTION 4 gbt_var_decompress(internal) ,
    FUNCTION 5 gbt_bit_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_bit_picksplit(internal,internal) ,
    FUNCTION 7 gbt_bit_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_bit_ops USING gist OWNER TO postgres;

--
-- TOC entry 2396 (class 2616 OID 16721)
-- Dependencies: 1072 2555 6
-- Name: gist_bpchar_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_bpchar_ops
    DEFAULT FOR TYPE character USING gist AS
    STORAGE gbtreekey_var ,
    OPERATOR 1 <(character,character) ,
    OPERATOR 2 <=(character,character) ,
    OPERATOR 3 =(character,character) ,
    OPERATOR 4 >=(character,character) ,
    OPERATOR 5 >(character,character) ,
    FUNCTION 1 gbt_bpchar_consistent(internal,character,smallint) ,
    FUNCTION 2 gbt_text_union(bytea,internal) ,
    FUNCTION 3 gbt_bpchar_compress(internal) ,
    FUNCTION 4 gbt_var_decompress(internal) ,
    FUNCTION 5 gbt_text_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_text_picksplit(internal,internal) ,
    FUNCTION 7 gbt_text_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_bpchar_ops USING gist OWNER TO postgres;

--
-- TOC entry 2397 (class 2616 OID 16741)
-- Dependencies: 6 2556 1072
-- Name: gist_bytea_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_bytea_ops
    DEFAULT FOR TYPE bytea USING gist AS
    STORAGE gbtreekey_var ,
    OPERATOR 1 <(bytea,bytea) ,
    OPERATOR 2 <=(bytea,bytea) ,
    OPERATOR 3 =(bytea,bytea) ,
    OPERATOR 4 >=(bytea,bytea) ,
    OPERATOR 5 >(bytea,bytea) ,
    FUNCTION 1 gbt_bytea_consistent(internal,bytea,smallint) ,
    FUNCTION 2 gbt_bytea_union(bytea,internal) ,
    FUNCTION 3 gbt_bytea_compress(internal) ,
    FUNCTION 4 gbt_var_decompress(internal) ,
    FUNCTION 5 gbt_bytea_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_bytea_picksplit(internal,internal) ,
    FUNCTION 7 gbt_bytea_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_bytea_ops USING gist OWNER TO postgres;

--
-- TOC entry 2393 (class 2616 OID 16665)
-- Dependencies: 6 2552 1066
-- Name: gist_cash_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_cash_ops
    DEFAULT FOR TYPE money USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(money,money) ,
    OPERATOR 2 <=(money,money) ,
    OPERATOR 3 =(money,money) ,
    OPERATOR 4 >=(money,money) ,
    OPERATOR 5 >(money,money) ,
    FUNCTION 1 gbt_cash_consistent(internal,money,smallint) ,
    FUNCTION 2 gbt_cash_union(bytea,internal) ,
    FUNCTION 3 gbt_cash_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_cash_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_cash_picksplit(internal,internal) ,
    FUNCTION 7 gbt_cash_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_cash_ops USING gist OWNER TO postgres;

--
-- TOC entry 2402 (class 2616 OID 16829)
-- Dependencies: 6 1066 2561
-- Name: gist_cidr_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_cidr_ops
    DEFAULT FOR TYPE cidr USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(inet,inet) RECHECK ,
    OPERATOR 2 <=(inet,inet) RECHECK ,
    OPERATOR 3 =(inet,inet) RECHECK ,
    OPERATOR 4 >=(inet,inet) RECHECK ,
    OPERATOR 5 >(inet,inet) RECHECK ,
    FUNCTION 1 gbt_inet_consistent(internal,inet,smallint) ,
    FUNCTION 2 gbt_inet_union(bytea,internal) ,
    FUNCTION 3 gbt_inet_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_inet_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_inet_picksplit(internal,internal) ,
    FUNCTION 7 gbt_inet_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_cidr_ops USING gist OWNER TO postgres;

--
-- TOC entry 2404 (class 2616 OID 16908)
-- Dependencies: 6 2563 1078
-- Name: gist_cube_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_cube_ops
    DEFAULT FOR TYPE cube USING gist AS
    OPERATOR 3 &&(cube,cube) ,
    OPERATOR 6 =(cube,cube) ,
    OPERATOR 7 @>(cube,cube) ,
    OPERATOR 8 <@(cube,cube) ,
    OPERATOR 13 @(cube,cube) ,
    OPERATOR 14 ~(cube,cube) ,
    FUNCTION 1 g_cube_consistent(internal,cube,integer) ,
    FUNCTION 2 g_cube_union(internal,internal) ,
    FUNCTION 3 g_cube_compress(internal) ,
    FUNCTION 4 g_cube_decompress(internal) ,
    FUNCTION 5 g_cube_penalty(internal,internal,internal) ,
    FUNCTION 6 g_cube_picksplit(internal,internal) ,
    FUNCTION 7 g_cube_same(cube,cube,internal);


ALTER OPERATOR CLASS public.gist_cube_ops USING gist OWNER TO postgres;

--
-- TOC entry 2391 (class 2616 OID 16624)
-- Dependencies: 1063 2550 6
-- Name: gist_date_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_date_ops
    DEFAULT FOR TYPE date USING gist AS
    STORAGE gbtreekey8 ,
    OPERATOR 1 <(date,date) ,
    OPERATOR 2 <=(date,date) ,
    OPERATOR 3 =(date,date) ,
    OPERATOR 4 >=(date,date) ,
    OPERATOR 5 >(date,date) ,
    FUNCTION 1 gbt_date_consistent(internal,date,smallint) ,
    FUNCTION 2 gbt_date_union(bytea,internal) ,
    FUNCTION 3 gbt_date_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_date_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_date_picksplit(internal,internal) ,
    FUNCTION 7 gbt_date_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_date_ops USING gist OWNER TO postgres;

--
-- TOC entry 2385 (class 2616 OID 16512)
-- Dependencies: 2544 6 1063
-- Name: gist_float4_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_float4_ops
    DEFAULT FOR TYPE real USING gist AS
    STORAGE gbtreekey8 ,
    OPERATOR 1 <(real,real) ,
    OPERATOR 2 <=(real,real) ,
    OPERATOR 3 =(real,real) ,
    OPERATOR 4 >=(real,real) ,
    OPERATOR 5 >(real,real) ,
    FUNCTION 1 gbt_float4_consistent(internal,real,smallint) ,
    FUNCTION 2 gbt_float4_union(bytea,internal) ,
    FUNCTION 3 gbt_float4_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_float4_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_float4_picksplit(internal,internal) ,
    FUNCTION 7 gbt_float4_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_float4_ops USING gist OWNER TO postgres;

--
-- TOC entry 2386 (class 2616 OID 16532)
-- Dependencies: 2545 6 1066
-- Name: gist_float8_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_float8_ops
    DEFAULT FOR TYPE double precision USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(double precision,double precision) ,
    OPERATOR 2 <=(double precision,double precision) ,
    OPERATOR 3 =(double precision,double precision) ,
    OPERATOR 4 >=(double precision,double precision) ,
    OPERATOR 5 >(double precision,double precision) ,
    FUNCTION 1 gbt_float8_consistent(internal,double precision,smallint) ,
    FUNCTION 2 gbt_float8_union(bytea,internal) ,
    FUNCTION 3 gbt_float8_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_float8_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_float8_picksplit(internal,internal) ,
    FUNCTION 7 gbt_float8_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_float8_ops USING gist OWNER TO postgres;

--
-- TOC entry 2405 (class 2616 OID 17023)
-- Dependencies: 1087 2564 6 1090
-- Name: gist_hstore_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_hstore_ops
    DEFAULT FOR TYPE hstore USING gist AS
    STORAGE ghstore ,
    OPERATOR 7 @>(hstore,hstore) RECHECK ,
    OPERATOR 9 ?(hstore,text) RECHECK ,
    OPERATOR 13 @(hstore,hstore) RECHECK ,
    FUNCTION 1 ghstore_consistent(internal,internal,integer) ,
    FUNCTION 2 ghstore_union(internal,internal) ,
    FUNCTION 3 ghstore_compress(internal) ,
    FUNCTION 4 ghstore_decompress(internal) ,
    FUNCTION 5 ghstore_penalty(internal,internal,internal) ,
    FUNCTION 6 ghstore_picksplit(internal,internal) ,
    FUNCTION 7 ghstore_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_hstore_ops USING gist OWNER TO postgres;

--
-- TOC entry 2401 (class 2616 OID 16815)
-- Dependencies: 6 1066 2560
-- Name: gist_inet_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_inet_ops
    DEFAULT FOR TYPE inet USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(inet,inet) RECHECK ,
    OPERATOR 2 <=(inet,inet) RECHECK ,
    OPERATOR 3 =(inet,inet) RECHECK ,
    OPERATOR 4 >=(inet,inet) RECHECK ,
    OPERATOR 5 >(inet,inet) RECHECK ,
    FUNCTION 1 gbt_inet_consistent(internal,inet,smallint) ,
    FUNCTION 2 gbt_inet_union(bytea,internal) ,
    FUNCTION 3 gbt_inet_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_inet_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_inet_picksplit(internal,internal) ,
    FUNCTION 7 gbt_inet_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_inet_ops USING gist OWNER TO postgres;

--
-- TOC entry 2382 (class 2616 OID 16452)
-- Dependencies: 2541 6 1024
-- Name: gist_int2_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_int2_ops
    DEFAULT FOR TYPE smallint USING gist AS
    STORAGE gbtreekey4 ,
    OPERATOR 1 <(smallint,smallint) ,
    OPERATOR 2 <=(smallint,smallint) ,
    OPERATOR 3 =(smallint,smallint) ,
    OPERATOR 4 >=(smallint,smallint) ,
    OPERATOR 5 >(smallint,smallint) ,
    FUNCTION 1 gbt_int2_consistent(internal,smallint,smallint) ,
    FUNCTION 2 gbt_int2_union(bytea,internal) ,
    FUNCTION 3 gbt_int2_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_int2_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_int2_picksplit(internal,internal) ,
    FUNCTION 7 gbt_int2_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_int2_ops USING gist OWNER TO postgres;

--
-- TOC entry 2383 (class 2616 OID 16472)
-- Dependencies: 1063 6 2542
-- Name: gist_int4_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_int4_ops
    DEFAULT FOR TYPE integer USING gist AS
    STORAGE gbtreekey8 ,
    OPERATOR 1 <(integer,integer) ,
    OPERATOR 2 <=(integer,integer) ,
    OPERATOR 3 =(integer,integer) ,
    OPERATOR 4 >=(integer,integer) ,
    OPERATOR 5 >(integer,integer) ,
    FUNCTION 1 gbt_int4_consistent(internal,integer,smallint) ,
    FUNCTION 2 gbt_int4_union(bytea,internal) ,
    FUNCTION 3 gbt_int4_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_int4_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_int4_picksplit(internal,internal) ,
    FUNCTION 7 gbt_int4_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_int4_ops USING gist OWNER TO postgres;

--
-- TOC entry 2384 (class 2616 OID 16492)
-- Dependencies: 1066 2543 6
-- Name: gist_int8_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_int8_ops
    DEFAULT FOR TYPE bigint USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(bigint,bigint) ,
    OPERATOR 2 <=(bigint,bigint) ,
    OPERATOR 3 =(bigint,bigint) ,
    OPERATOR 4 >=(bigint,bigint) ,
    OPERATOR 5 >(bigint,bigint) ,
    FUNCTION 1 gbt_int8_consistent(internal,bigint,smallint) ,
    FUNCTION 2 gbt_int8_union(bytea,internal) ,
    FUNCTION 3 gbt_int8_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_int8_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_int8_picksplit(internal,internal) ,
    FUNCTION 7 gbt_int8_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_int8_ops USING gist OWNER TO postgres;

--
-- TOC entry 2392 (class 2616 OID 16645)
-- Dependencies: 6 2551 1069
-- Name: gist_interval_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_interval_ops
    DEFAULT FOR TYPE interval USING gist AS
    STORAGE gbtreekey32 ,
    OPERATOR 1 <(interval,interval) ,
    OPERATOR 2 <=(interval,interval) ,
    OPERATOR 3 =(interval,interval) ,
    OPERATOR 4 >=(interval,interval) ,
    OPERATOR 5 >(interval,interval) ,
    FUNCTION 1 gbt_intv_consistent(internal,interval,smallint) ,
    FUNCTION 2 gbt_intv_union(bytea,internal) ,
    FUNCTION 3 gbt_intv_compress(internal) ,
    FUNCTION 4 gbt_intv_decompress(internal) ,
    FUNCTION 5 gbt_intv_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_intv_picksplit(internal,internal) ,
    FUNCTION 7 gbt_intv_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_interval_ops USING gist OWNER TO postgres;

--
-- TOC entry 2427 (class 2616 OID 17925)
-- Dependencies: 6 2572 1124 1133
-- Name: gist_ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_ltree_ops
    DEFAULT FOR TYPE ltree USING gist AS
    STORAGE ltree_gist ,
    OPERATOR 1 <(ltree,ltree) ,
    OPERATOR 2 <=(ltree,ltree) ,
    OPERATOR 3 =(ltree,ltree) ,
    OPERATOR 4 >=(ltree,ltree) ,
    OPERATOR 5 >(ltree,ltree) ,
    OPERATOR 10 @>(ltree,ltree) ,
    OPERATOR 11 <@(ltree,ltree) ,
    OPERATOR 12 ~(ltree,lquery) ,
    OPERATOR 13 ~(lquery,ltree) ,
    OPERATOR 14 @(ltree,ltxtquery) ,
    OPERATOR 15 @(ltxtquery,ltree) ,
    OPERATOR 16 ?(ltree,lquery[]) ,
    OPERATOR 17 ?(lquery[],ltree) ,
    FUNCTION 1 ltree_consistent(internal,internal,smallint) ,
    FUNCTION 2 ltree_union(internal,internal) ,
    FUNCTION 3 ltree_compress(internal) ,
    FUNCTION 4 ltree_decompress(internal) ,
    FUNCTION 5 ltree_penalty(internal,internal,internal) ,
    FUNCTION 6 ltree_picksplit(internal,internal) ,
    FUNCTION 7 ltree_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_ltree_ops USING gist OWNER TO postgres;

--
-- TOC entry 2394 (class 2616 OID 16685)
-- Dependencies: 1066 2553 6
-- Name: gist_macaddr_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_macaddr_ops
    DEFAULT FOR TYPE macaddr USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(macaddr,macaddr) ,
    OPERATOR 2 <=(macaddr,macaddr) ,
    OPERATOR 3 =(macaddr,macaddr) ,
    OPERATOR 4 >=(macaddr,macaddr) ,
    OPERATOR 5 >(macaddr,macaddr) ,
    FUNCTION 1 gbt_macad_consistent(internal,macaddr,smallint) ,
    FUNCTION 2 gbt_macad_union(bytea,internal) ,
    FUNCTION 3 gbt_macad_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_macad_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_macad_picksplit(internal,internal) ,
    FUNCTION 7 gbt_macad_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_macaddr_ops USING gist OWNER TO postgres;

--
-- TOC entry 2398 (class 2616 OID 16761)
-- Dependencies: 6 2557 1072
-- Name: gist_numeric_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_numeric_ops
    DEFAULT FOR TYPE numeric USING gist AS
    STORAGE gbtreekey_var ,
    OPERATOR 1 <(numeric,numeric) ,
    OPERATOR 2 <=(numeric,numeric) ,
    OPERATOR 3 =(numeric,numeric) ,
    OPERATOR 4 >=(numeric,numeric) ,
    OPERATOR 5 >(numeric,numeric) ,
    FUNCTION 1 gbt_numeric_consistent(internal,numeric,smallint) ,
    FUNCTION 2 gbt_numeric_union(bytea,internal) ,
    FUNCTION 3 gbt_numeric_compress(internal) ,
    FUNCTION 4 gbt_var_decompress(internal) ,
    FUNCTION 5 gbt_numeric_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_numeric_picksplit(internal,internal) ,
    FUNCTION 7 gbt_numeric_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_numeric_ops USING gist OWNER TO postgres;

--
-- TOC entry 2381 (class 2616 OID 16432)
-- Dependencies: 1063 2540 6
-- Name: gist_oid_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_oid_ops
    DEFAULT FOR TYPE oid USING gist AS
    STORAGE gbtreekey8 ,
    OPERATOR 1 <(oid,oid) ,
    OPERATOR 2 <=(oid,oid) ,
    OPERATOR 3 =(oid,oid) ,
    OPERATOR 4 >=(oid,oid) ,
    OPERATOR 5 >(oid,oid) ,
    FUNCTION 1 gbt_oid_consistent(internal,oid,smallint) ,
    FUNCTION 2 gbt_oid_union(bytea,internal) ,
    FUNCTION 3 gbt_oid_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_oid_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_oid_picksplit(internal,internal) ,
    FUNCTION 7 gbt_oid_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_oid_ops USING gist OWNER TO postgres;

--
-- TOC entry 2432 (class 2616 OID 18156)
-- Dependencies: 6 1145 2577
-- Name: gist_seg_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_seg_ops
    DEFAULT FOR TYPE seg USING gist AS
    OPERATOR 1 <<(seg,seg) ,
    OPERATOR 2 &<(seg,seg) ,
    OPERATOR 3 &&(seg,seg) ,
    OPERATOR 4 &>(seg,seg) ,
    OPERATOR 5 >>(seg,seg) ,
    OPERATOR 6 =(seg,seg) ,
    OPERATOR 7 @>(seg,seg) ,
    OPERATOR 8 <@(seg,seg) ,
    OPERATOR 13 @(seg,seg) ,
    OPERATOR 14 ~(seg,seg) ,
    FUNCTION 1 gseg_consistent(internal,seg,integer) ,
    FUNCTION 2 gseg_union(internal,internal) ,
    FUNCTION 3 gseg_compress(internal) ,
    FUNCTION 4 gseg_decompress(internal) ,
    FUNCTION 5 gseg_penalty(internal,internal,internal) ,
    FUNCTION 6 gseg_picksplit(internal,internal) ,
    FUNCTION 7 gseg_same(seg,seg,internal);


ALTER OPERATOR CLASS public.gist_seg_ops USING gist OWNER TO postgres;

--
-- TOC entry 2395 (class 2616 OID 16707)
-- Dependencies: 6 2554 1072
-- Name: gist_text_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_text_ops
    DEFAULT FOR TYPE text USING gist AS
    STORAGE gbtreekey_var ,
    OPERATOR 1 <(text,text) ,
    OPERATOR 2 <=(text,text) ,
    OPERATOR 3 =(text,text) ,
    OPERATOR 4 >=(text,text) ,
    OPERATOR 5 >(text,text) ,
    FUNCTION 1 gbt_text_consistent(internal,text,smallint) ,
    FUNCTION 2 gbt_text_union(bytea,internal) ,
    FUNCTION 3 gbt_text_compress(internal) ,
    FUNCTION 4 gbt_var_decompress(internal) ,
    FUNCTION 5 gbt_text_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_text_picksplit(internal,internal) ,
    FUNCTION 7 gbt_text_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_text_ops USING gist OWNER TO postgres;

--
-- TOC entry 2389 (class 2616 OID 16590)
-- Dependencies: 2548 6 1066
-- Name: gist_time_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_time_ops
    DEFAULT FOR TYPE time without time zone USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(time without time zone,time without time zone) ,
    OPERATOR 2 <=(time without time zone,time without time zone) ,
    OPERATOR 3 =(time without time zone,time without time zone) ,
    OPERATOR 4 >=(time without time zone,time without time zone) ,
    OPERATOR 5 >(time without time zone,time without time zone) ,
    FUNCTION 1 gbt_time_consistent(internal,time without time zone,smallint) ,
    FUNCTION 2 gbt_time_union(bytea,internal) ,
    FUNCTION 3 gbt_time_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_time_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_time_picksplit(internal,internal) ,
    FUNCTION 7 gbt_time_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_time_ops USING gist OWNER TO postgres;

--
-- TOC entry 2387 (class 2616 OID 16554)
-- Dependencies: 2546 6 1066
-- Name: gist_timestamp_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_timestamp_ops
    DEFAULT FOR TYPE timestamp without time zone USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(timestamp without time zone,timestamp without time zone) ,
    OPERATOR 2 <=(timestamp without time zone,timestamp without time zone) ,
    OPERATOR 3 =(timestamp without time zone,timestamp without time zone) ,
    OPERATOR 4 >=(timestamp without time zone,timestamp without time zone) ,
    OPERATOR 5 >(timestamp without time zone,timestamp without time zone) ,
    FUNCTION 1 gbt_ts_consistent(internal,timestamp without time zone,smallint) ,
    FUNCTION 2 gbt_ts_union(bytea,internal) ,
    FUNCTION 3 gbt_ts_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_ts_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_ts_picksplit(internal,internal) ,
    FUNCTION 7 gbt_ts_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_timestamp_ops USING gist OWNER TO postgres;

--
-- TOC entry 2388 (class 2616 OID 16568)
-- Dependencies: 2547 1066 6
-- Name: gist_timestamptz_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_timestamptz_ops
    DEFAULT FOR TYPE timestamp with time zone USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(timestamp with time zone,timestamp with time zone) ,
    OPERATOR 2 <=(timestamp with time zone,timestamp with time zone) ,
    OPERATOR 3 =(timestamp with time zone,timestamp with time zone) ,
    OPERATOR 4 >=(timestamp with time zone,timestamp with time zone) ,
    OPERATOR 5 >(timestamp with time zone,timestamp with time zone) ,
    FUNCTION 1 gbt_tstz_consistent(internal,timestamp with time zone,smallint) ,
    FUNCTION 2 gbt_ts_union(bytea,internal) ,
    FUNCTION 3 gbt_tstz_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_ts_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_ts_picksplit(internal,internal) ,
    FUNCTION 7 gbt_ts_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_timestamptz_ops USING gist OWNER TO postgres;

--
-- TOC entry 2390 (class 2616 OID 16604)
-- Dependencies: 1066 6 2549
-- Name: gist_timetz_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_timetz_ops
    DEFAULT FOR TYPE time with time zone USING gist AS
    STORAGE gbtreekey16 ,
    OPERATOR 1 <(time with time zone,time with time zone) RECHECK ,
    OPERATOR 2 <=(time with time zone,time with time zone) RECHECK ,
    OPERATOR 3 =(time with time zone,time with time zone) RECHECK ,
    OPERATOR 4 >=(time with time zone,time with time zone) RECHECK ,
    OPERATOR 5 >(time with time zone,time with time zone) RECHECK ,
    FUNCTION 1 gbt_timetz_consistent(internal,time with time zone,smallint) ,
    FUNCTION 2 gbt_time_union(bytea,internal) ,
    FUNCTION 3 gbt_timetz_compress(internal) ,
    FUNCTION 4 gbt_decompress(internal) ,
    FUNCTION 5 gbt_time_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_time_picksplit(internal,internal) ,
    FUNCTION 7 gbt_time_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_timetz_ops USING gist OWNER TO postgres;

--
-- TOC entry 2429 (class 2616 OID 18046)
-- Dependencies: 6 1142 2574
-- Name: gist_trgm_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_trgm_ops
    FOR TYPE text USING gist AS
    STORAGE gtrgm ,
    OPERATOR 1 %(text,text) ,
    FUNCTION 1 gtrgm_consistent(gtrgm,internal,integer) ,
    FUNCTION 2 gtrgm_union(bytea,internal) ,
    FUNCTION 3 gtrgm_compress(internal) ,
    FUNCTION 4 gtrgm_decompress(internal) ,
    FUNCTION 5 gtrgm_penalty(internal,internal,internal) ,
    FUNCTION 6 gtrgm_picksplit(internal,internal) ,
    FUNCTION 7 gtrgm_same(gtrgm,gtrgm,internal);


ALTER OPERATOR CLASS public.gist_trgm_ops USING gist OWNER TO postgres;

--
-- TOC entry 2400 (class 2616 OID 16795)
-- Dependencies: 1072 6 2559
-- Name: gist_vbit_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_vbit_ops
    DEFAULT FOR TYPE bit varying USING gist AS
    STORAGE gbtreekey_var ,
    OPERATOR 1 <(bit varying,bit varying) ,
    OPERATOR 2 <=(bit varying,bit varying) ,
    OPERATOR 3 =(bit varying,bit varying) ,
    OPERATOR 4 >=(bit varying,bit varying) ,
    OPERATOR 5 >(bit varying,bit varying) ,
    FUNCTION 1 gbt_bit_consistent(internal,bit,smallint) ,
    FUNCTION 2 gbt_bit_union(bytea,internal) ,
    FUNCTION 3 gbt_bit_compress(internal) ,
    FUNCTION 4 gbt_var_decompress(internal) ,
    FUNCTION 5 gbt_bit_penalty(internal,internal,internal) ,
    FUNCTION 6 gbt_bit_picksplit(internal,internal) ,
    FUNCTION 7 gbt_bit_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_vbit_ops USING gist OWNER TO postgres;

--
-- TOC entry 2412 (class 2616 OID 17598)
-- Dependencies: 1102 2569 6
-- Name: isbn13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS isbn13_ops
    DEFAULT FOR TYPE isbn13 USING btree FAMILY isn_ops AS
    OPERATOR 1 <(isbn13,isbn13) ,
    OPERATOR 2 <=(isbn13,isbn13) ,
    OPERATOR 3 =(isbn13,isbn13) ,
    OPERATOR 4 >=(isbn13,isbn13) ,
    OPERATOR 5 >(isbn13,isbn13) ,
    FUNCTION 1 btisbn13cmp(isbn13,isbn13);


ALTER OPERATOR CLASS public.isbn13_ops USING btree OWNER TO postgres;

--
-- TOC entry 2413 (class 2616 OID 17606)
-- Dependencies: 2570 1102 6
-- Name: isbn13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS isbn13_ops
    DEFAULT FOR TYPE isbn13 USING hash FAMILY isn_ops AS
    OPERATOR 1 =(isbn13,isbn13) ,
    FUNCTION 1 hashisbn13(isbn13);


ALTER OPERATOR CLASS public.isbn13_ops USING hash OWNER TO postgres;

--
-- TOC entry 2414 (class 2616 OID 17626)
-- Dependencies: 2569 1111 6
-- Name: isbn_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS isbn_ops
    DEFAULT FOR TYPE isbn USING btree FAMILY isn_ops AS
    OPERATOR 1 <(isbn,isbn) ,
    OPERATOR 2 <=(isbn,isbn) ,
    OPERATOR 3 =(isbn,isbn) ,
    OPERATOR 4 >=(isbn,isbn) ,
    OPERATOR 5 >(isbn,isbn) ,
    FUNCTION 1 btisbncmp(isbn,isbn);


ALTER OPERATOR CLASS public.isbn_ops USING btree OWNER TO postgres;

--
-- TOC entry 2415 (class 2616 OID 17634)
-- Dependencies: 1111 2570 6
-- Name: isbn_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS isbn_ops
    DEFAULT FOR TYPE isbn USING hash FAMILY isn_ops AS
    OPERATOR 1 =(isbn,isbn) ,
    FUNCTION 1 hashisbn(isbn);


ALTER OPERATOR CLASS public.isbn_ops USING hash OWNER TO postgres;

--
-- TOC entry 2416 (class 2616 OID 17654)
-- Dependencies: 1105 2569 6
-- Name: ismn13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ismn13_ops
    DEFAULT FOR TYPE ismn13 USING btree FAMILY isn_ops AS
    OPERATOR 1 <(ismn13,ismn13) ,
    OPERATOR 2 <=(ismn13,ismn13) ,
    OPERATOR 3 =(ismn13,ismn13) ,
    OPERATOR 4 >=(ismn13,ismn13) ,
    OPERATOR 5 >(ismn13,ismn13) ,
    FUNCTION 1 btismn13cmp(ismn13,ismn13);


ALTER OPERATOR CLASS public.ismn13_ops USING btree OWNER TO postgres;

--
-- TOC entry 2417 (class 2616 OID 17662)
-- Dependencies: 6 1105 2570
-- Name: ismn13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ismn13_ops
    DEFAULT FOR TYPE ismn13 USING hash FAMILY isn_ops AS
    OPERATOR 1 =(ismn13,ismn13) ,
    FUNCTION 1 hashismn13(ismn13);


ALTER OPERATOR CLASS public.ismn13_ops USING hash OWNER TO postgres;

--
-- TOC entry 2418 (class 2616 OID 17682)
-- Dependencies: 2569 1114 6
-- Name: ismn_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ismn_ops
    DEFAULT FOR TYPE ismn USING btree FAMILY isn_ops AS
    OPERATOR 1 <(ismn,ismn) ,
    OPERATOR 2 <=(ismn,ismn) ,
    OPERATOR 3 =(ismn,ismn) ,
    OPERATOR 4 >=(ismn,ismn) ,
    OPERATOR 5 >(ismn,ismn) ,
    FUNCTION 1 btismncmp(ismn,ismn);


ALTER OPERATOR CLASS public.ismn_ops USING btree OWNER TO postgres;

--
-- TOC entry 2419 (class 2616 OID 17690)
-- Dependencies: 6 1114 2570
-- Name: ismn_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ismn_ops
    DEFAULT FOR TYPE ismn USING hash FAMILY isn_ops AS
    OPERATOR 1 =(ismn,ismn) ,
    FUNCTION 1 hashismn(ismn);


ALTER OPERATOR CLASS public.ismn_ops USING hash OWNER TO postgres;

--
-- TOC entry 2420 (class 2616 OID 17710)
-- Dependencies: 2569 6 1108
-- Name: issn13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS issn13_ops
    DEFAULT FOR TYPE issn13 USING btree FAMILY isn_ops AS
    OPERATOR 1 <(issn13,issn13) ,
    OPERATOR 2 <=(issn13,issn13) ,
    OPERATOR 3 =(issn13,issn13) ,
    OPERATOR 4 >=(issn13,issn13) ,
    OPERATOR 5 >(issn13,issn13) ,
    FUNCTION 1 btissn13cmp(issn13,issn13);


ALTER OPERATOR CLASS public.issn13_ops USING btree OWNER TO postgres;

--
-- TOC entry 2421 (class 2616 OID 17718)
-- Dependencies: 6 1108 2570
-- Name: issn13_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS issn13_ops
    DEFAULT FOR TYPE issn13 USING hash FAMILY isn_ops AS
    OPERATOR 1 =(issn13,issn13) ,
    FUNCTION 1 hashissn13(issn13);


ALTER OPERATOR CLASS public.issn13_ops USING hash OWNER TO postgres;

--
-- TOC entry 2422 (class 2616 OID 17738)
-- Dependencies: 6 1117 2569
-- Name: issn_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS issn_ops
    DEFAULT FOR TYPE issn USING btree FAMILY isn_ops AS
    OPERATOR 1 <(issn,issn) ,
    OPERATOR 2 <=(issn,issn) ,
    OPERATOR 3 =(issn,issn) ,
    OPERATOR 4 >=(issn,issn) ,
    OPERATOR 5 >(issn,issn) ,
    FUNCTION 1 btissncmp(issn,issn);


ALTER OPERATOR CLASS public.issn_ops USING btree OWNER TO postgres;

--
-- TOC entry 2423 (class 2616 OID 17746)
-- Dependencies: 2570 1117 6
-- Name: issn_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS issn_ops
    DEFAULT FOR TYPE issn USING hash FAMILY isn_ops AS
    OPERATOR 1 =(issn,issn) ,
    FUNCTION 1 hashissn(issn);


ALTER OPERATOR CLASS public.issn_ops USING hash OWNER TO postgres;

--
-- TOC entry 2426 (class 2616 OID 17880)
-- Dependencies: 1124 6 2571
-- Name: ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS ltree_ops
    DEFAULT FOR TYPE ltree USING btree AS
    OPERATOR 1 <(ltree,ltree) ,
    OPERATOR 2 <=(ltree,ltree) ,
    OPERATOR 3 =(ltree,ltree) ,
    OPERATOR 4 >=(ltree,ltree) ,
    OPERATOR 5 >(ltree,ltree) ,
    FUNCTION 1 ltree_cmp(ltree,ltree);


ALTER OPERATOR CLASS public.ltree_ops USING btree OWNER TO postgres;

--
-- TOC entry 2431 (class 2616 OID 18148)
-- Dependencies: 6 2576 1145
-- Name: seg_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS seg_ops
    DEFAULT FOR TYPE seg USING btree AS
    OPERATOR 1 <(seg,seg) ,
    OPERATOR 2 <=(seg,seg) ,
    OPERATOR 3 =(seg,seg) ,
    OPERATOR 4 >=(seg,seg) ,
    OPERATOR 5 >(seg,seg) ,
    FUNCTION 1 seg_cmp(seg,seg);


ALTER OPERATOR CLASS public.seg_ops USING btree OWNER TO postgres;

--
-- TOC entry 2424 (class 2616 OID 17766)
-- Dependencies: 1120 6 2569
-- Name: upc_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS upc_ops
    DEFAULT FOR TYPE upc USING btree FAMILY isn_ops AS
    OPERATOR 1 <(upc,upc) ,
    OPERATOR 2 <=(upc,upc) ,
    OPERATOR 3 =(upc,upc) ,
    OPERATOR 4 >=(upc,upc) ,
    OPERATOR 5 >(upc,upc) ,
    FUNCTION 1 btupccmp(upc,upc);


ALTER OPERATOR CLASS public.upc_ops USING btree OWNER TO postgres;

--
-- TOC entry 2425 (class 2616 OID 17774)
-- Dependencies: 6 2570 1120
-- Name: upc_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS upc_ops
    DEFAULT FOR TYPE upc USING hash FAMILY isn_ops AS
    OPERATOR 1 =(upc,upc) ,
    FUNCTION 1 hashupc(upc);


ALTER OPERATOR CLASS public.upc_ops USING hash OWNER TO postgres;

SET search_path = pg_catalog;

--
-- TOC entry 3198 (class 2605 OID 17793)
-- Dependencies: 534 1099 534 1111
-- Name: CAST (public.ean13 AS public.isbn); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.isbn) WITH FUNCTION public.isbn(public.ean13);


--
-- TOC entry 3195 (class 2605 OID 17792)
-- Dependencies: 531 531 1102 1099
-- Name: CAST (public.ean13 AS public.isbn13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.isbn13) WITH FUNCTION public.isbn13(public.ean13);


--
-- TOC entry 3199 (class 2605 OID 17795)
-- Dependencies: 535 535 1114 1099
-- Name: CAST (public.ean13 AS public.ismn); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.ismn) WITH FUNCTION public.ismn(public.ean13);


--
-- TOC entry 3196 (class 2605 OID 17794)
-- Dependencies: 532 532 1105 1099
-- Name: CAST (public.ean13 AS public.ismn13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.ismn13) WITH FUNCTION public.ismn13(public.ean13);


--
-- TOC entry 3200 (class 2605 OID 17797)
-- Dependencies: 536 1099 1117 536
-- Name: CAST (public.ean13 AS public.issn); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.issn) WITH FUNCTION public.issn(public.ean13);


--
-- TOC entry 3197 (class 2605 OID 17796)
-- Dependencies: 533 1099 1108 533
-- Name: CAST (public.ean13 AS public.issn13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.issn13) WITH FUNCTION public.issn13(public.ean13);


--
-- TOC entry 3201 (class 2605 OID 17798)
-- Dependencies: 537 1099 537 1120
-- Name: CAST (public.ean13 AS public.upc); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ean13 AS public.upc) WITH FUNCTION public.upc(public.ean13);


--
-- TOC entry 3208 (class 2605 OID 17800)
-- Dependencies: 1099 1111
-- Name: CAST (public.isbn AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.isbn AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3209 (class 2605 OID 17806)
-- Dependencies: 1111 1102
-- Name: CAST (public.isbn AS public.isbn13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.isbn AS public.isbn13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3202 (class 2605 OID 17799)
-- Dependencies: 1099 1102
-- Name: CAST (public.isbn13 AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.isbn13 AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3203 (class 2605 OID 17807)
-- Dependencies: 1102 1111
-- Name: CAST (public.isbn13 AS public.isbn); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.isbn13 AS public.isbn) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3210 (class 2605 OID 17802)
-- Dependencies: 1114 1099
-- Name: CAST (public.ismn AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ismn AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3211 (class 2605 OID 17808)
-- Dependencies: 1114 1105
-- Name: CAST (public.ismn AS public.ismn13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ismn AS public.ismn13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3204 (class 2605 OID 17801)
-- Dependencies: 1105 1099
-- Name: CAST (public.ismn13 AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ismn13 AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3205 (class 2605 OID 17809)
-- Dependencies: 1105 1114
-- Name: CAST (public.ismn13 AS public.ismn); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.ismn13 AS public.ismn) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3212 (class 2605 OID 17804)
-- Dependencies: 1099 1117
-- Name: CAST (public.issn AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.issn AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3213 (class 2605 OID 17810)
-- Dependencies: 1117 1108
-- Name: CAST (public.issn AS public.issn13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.issn AS public.issn13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3206 (class 2605 OID 17803)
-- Dependencies: 1108 1099
-- Name: CAST (public.issn13 AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.issn13 AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3207 (class 2605 OID 17811)
-- Dependencies: 1108 1117
-- Name: CAST (public.issn13 AS public.issn); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.issn13 AS public.issn) WITHOUT FUNCTION AS ASSIGNMENT;


--
-- TOC entry 3214 (class 2605 OID 17805)
-- Dependencies: 1120 1099
-- Name: CAST (public.upc AS public.ean13); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.upc AS public.ean13) WITHOUT FUNCTION AS ASSIGNMENT;


SET search_path = public, pg_catalog;

--
-- TOC entry 2879 (class 1259 OID 18652)
-- Dependencies: 2880 6
-- Name: TrackDates_ID_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE "TrackDates_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."TrackDates_ID_seq" OWNER TO trackit_user;

--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 2879
-- Name: TrackDates_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE "TrackDates_ID_seq" OWNED BY trackdates.id;


--
-- TOC entry 2840 (class 1259 OID 18306)
-- Dependencies: 6 2841
-- Name: commoncontent_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE commoncontent_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.commoncontent_id_seq OWNER TO trackit_user;

--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 2840
-- Name: commoncontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE commoncontent_id_seq OWNED BY commoncontent.id;


--
-- TOC entry 2842 (class 1259 OID 18318)
-- Dependencies: 2843 6
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE companies_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO trackit_user;

--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 2842
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- TOC entry 2911 (class 1259 OID 35317)
-- Dependencies: 6 2912
-- Name: companyproperty_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE companyproperty_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.companyproperty_id_seq OWNER TO trackit_user;

--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 2911
-- Name: companyproperty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE companyproperty_id_seq OWNED BY companyproperties.id;


--
-- TOC entry 2909 (class 1259 OID 35290)
-- Dependencies: 2910 6
-- Name: companypropertytype_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE companypropertytype_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.companypropertytype_id_seq OWNER TO trackit_user;

--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 2909
-- Name: companypropertytype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE companypropertytype_id_seq OWNED BY companypropertytypes.id;


--
-- TOC entry 2901 (class 1259 OID 26990)
-- Dependencies: 2902 6
-- Name: container_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE container_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.container_id_seq OWNER TO trackit_user;

--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 2901
-- Name: container_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE container_id_seq OWNED BY containers.id;


--
-- TOC entry 2903 (class 1259 OID 26999)
-- Dependencies: 2904 6
-- Name: containertypes_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE containertypes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.containertypes_id_seq OWNER TO trackit_user;

--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 2903
-- Name: containertypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE containertypes_id_seq OWNED BY containertypes.id;


--
-- TOC entry 2907 (class 1259 OID 35272)
-- Dependencies: 6 2908
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE countries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO trackit_user;

--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 2907
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- TOC entry 2844 (class 1259 OID 18328)
-- Dependencies: 2845 6
-- Name: cultures_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE cultures_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cultures_id_seq OWNER TO trackit_user;

--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 2844
-- Name: cultures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE cultures_id_seq OWNED BY cultures.id;


--
-- TOC entry 2889 (class 1259 OID 18795)
-- Dependencies: 2890 6
-- Name: devicetype_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE devicetype_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicetype_id_seq OWNER TO trackit_user;

--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 2889
-- Name: devicetype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE devicetype_id_seq OWNED BY devicetypes.id;


--
-- TOC entry 2895 (class 1259 OID 26944)
-- Dependencies: 2896 6
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE events_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO trackit_user;

--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 2895
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- TOC entry 2897 (class 1259 OID 26953)
-- Dependencies: 2898 6
-- Name: eventtypes_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE eventtypes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.eventtypes_id_seq OWNER TO trackit_user;

--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 2897
-- Name: eventtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE eventtypes_id_seq OWNED BY eventtypes.id;


--
-- TOC entry 2905 (class 1259 OID 35145)
-- Dependencies: 2906 6
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE files_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.files_id_seq OWNER TO trackit_user;

--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 2905
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE files_id_seq OWNED BY files.id;


--
-- TOC entry 2874 (class 1259 OID 18534)
-- Dependencies: 2875 6
-- Name: formatsdate_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE formatsdate_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formatsdate_id_seq OWNER TO trackit_user;

--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 2874
-- Name: formatsdate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE formatsdate_id_seq OWNED BY formatsdate.id;


--
-- TOC entry 2872 (class 1259 OID 18525)
-- Dependencies: 6 2873
-- Name: formatsmetrage_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE formatsmetrage_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formatsmetrage_id_seq OWNER TO trackit_user;

--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 2872
-- Name: formatsmetrage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE formatsmetrage_id_seq OWNED BY formatsdistance.id;


--
-- TOC entry 2870 (class 1259 OID 18516)
-- Dependencies: 6 2871
-- Name: formatstemperature_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE formatstemperature_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formatstemperature_id_seq OWNER TO trackit_user;

--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 2870
-- Name: formatstemperature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE formatstemperature_id_seq OWNED BY formatstemperature.id;


--
-- TOC entry 2868 (class 1259 OID 18507)
-- Dependencies: 6 2869
-- Name: formatstime_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE formatstime_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formatstime_id_seq OWNER TO trackit_user;

--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 2868
-- Name: formatstime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE formatstime_id_seq OWNED BY formatstime.id;


--
-- TOC entry 2893 (class 1259 OID 18835)
-- Dependencies: 6 2894
-- Name: gpsdata_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE gpsdata_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.gpsdata_id_seq OWNER TO trackit_user;

--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 2893
-- Name: gpsdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE gpsdata_id_seq OWNED BY containermove.id;


--
-- TOC entry 2866 (class 1259 OID 18494)
-- Dependencies: 2867 6
-- Name: gpspoints_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE gpspoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.gpspoints_id_seq OWNER TO trackit_user;

--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 2866
-- Name: gpspoints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE gpspoints_id_seq OWNED BY gpspoints.id;


--
-- TOC entry 2864 (class 1259 OID 18485)
-- Dependencies: 6 2865
-- Name: iuservsiuser_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE iuservsiuser_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.iuservsiuser_id_seq OWNER TO trackit_user;

--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 2864
-- Name: iuservsiuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE iuservsiuser_id_seq OWNED BY iuservsiuser.id;


--
-- TOC entry 2862 (class 1259 OID 18469)
-- Dependencies: 2863 6
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO trackit_user;

--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 2862
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- TOC entry 2899 (class 1259 OID 26978)
-- Dependencies: 6 2900
-- Name: objecttypes_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE objecttypes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.objecttypes_id_seq OWNER TO trackit_user;

--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 2899
-- Name: objecttypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE objecttypes_id_seq OWNED BY objecttypes.id;


--
-- TOC entry 2860 (class 1259 OID 18459)
-- Dependencies: 2861 6
-- Name: realty_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE realty_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.realty_id_seq OWNER TO trackit_user;

--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 2860
-- Name: realty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE realty_id_seq OWNED BY location.id;


--
-- TOC entry 2858 (class 1259 OID 18449)
-- Dependencies: 6 2859
-- Name: realtyvsuser_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE realtyvsuser_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.realtyvsuser_id_seq OWNER TO trackit_user;

--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 2858
-- Name: realtyvsuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE realtyvsuser_id_seq OWNED BY locationvsuser.id;


--
-- TOC entry 2856 (class 1259 OID 18440)
-- Dependencies: 6 2857
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.routes_id_seq OWNER TO trackit_user;

--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 2856
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE routes_id_seq OWNED BY routes.id;


--
-- TOC entry 2885 (class 1259 OID 18752)
-- Dependencies: 6 2886
-- Name: sensors_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE sensors_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sensors_id_seq OWNER TO trackit_user;

--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 2885
-- Name: sensors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE sensors_id_seq OWNED BY devices.id;


--
-- TOC entry 2887 (class 1259 OID 18762)
-- Dependencies: 2888 6
-- Name: sensorsdata_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE sensorsdata_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sensorsdata_id_seq OWNER TO trackit_user;

--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 2887
-- Name: sensorsdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE sensorsdata_id_seq OWNED BY sensorsdata.id;


--
-- TOC entry 2881 (class 1259 OID 18666)
-- Dependencies: 2882 6
-- Name: timezones_ID_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE "timezones_ID_seq"
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."timezones_ID_seq" OWNER TO trackit_user;

--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 2881
-- Name: timezones_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE "timezones_ID_seq" OWNED BY timezones.id;


--
-- TOC entry 2854 (class 1259 OID 18431)
-- Dependencies: 6 2855
-- Name: trackcontrolcheckpoints_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE trackcontrolcheckpoints_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.trackcontrolcheckpoints_id_seq OWNER TO trackit_user;

--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 2854
-- Name: trackcontrolcheckpoints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE trackcontrolcheckpoints_id_seq OWNED BY trackcontrolcheckpoints.id;


--
-- TOC entry 2852 (class 1259 OID 18423)
-- Dependencies: 6 2853
-- Name: trackcontroltemperatures_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE trackcontroltemperatures_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.trackcontroltemperatures_id_seq OWNER TO trackit_user;

--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 2852
-- Name: trackcontroltemperatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE trackcontroltemperatures_id_seq OWNED BY trackcontroltemperatures.id;


--
-- TOC entry 2850 (class 1259 OID 18412)
-- Dependencies: 2851 6
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE tracks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tracks_id_seq OWNER TO trackit_user;

--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 2850
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE tracks_id_seq OWNED BY tracks.id;


--
-- TOC entry 2883 (class 1259 OID 18730)
-- Dependencies: 6 2884
-- Name: trackstatuses_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE trackstatuses_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.trackstatuses_id_seq OWNER TO trackit_user;

--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 2883
-- Name: trackstatuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE trackstatuses_id_seq OWNED BY trackstatuses.id;


--
-- TOC entry 2891 (class 1259 OID 18816)
-- Dependencies: 6 2892
-- Name: trackvsdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE trackvsdevice_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.trackvsdevice_id_seq OWNER TO trackit_user;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 2891
-- Name: trackvsdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE trackvsdevice_id_seq OWNED BY containervsdevice.id;


--
-- TOC entry 2915 (class 1259 OID 51810)
-- Dependencies: 2916 6
-- Name: trackvsdevice_id_seq1; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE trackvsdevice_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.trackvsdevice_id_seq1 OWNER TO trackit_user;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 2915
-- Name: trackvsdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE trackvsdevice_id_seq1 OWNED BY trackvsdevice.id;


--
-- TOC entry 2917 (class 1259 OID 59919)
-- Dependencies: 2918 6
-- Name: userenvironment_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE userenvironment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.userenvironment_id_seq OWNER TO trackit_user;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 2917
-- Name: userenvironment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE userenvironment_id_seq OWNED BY usersenvironment.id;


--
-- TOC entry 2848 (class 1259 OID 18382)
-- Dependencies: 2849 6
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO trackit_user;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 2848
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 2876 (class 1259 OID 18607)
-- Dependencies: 2877 6
-- Name: uservscompany_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE uservscompany_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.uservscompany_id_seq OWNER TO trackit_user;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 2876
-- Name: uservscompany_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE uservscompany_id_seq OWNED BY uservscompany.id;


--
-- TOC entry 2846 (class 1259 OID 18337)
-- Dependencies: 2847 6
-- Name: webuicontent_id_seq; Type: SEQUENCE; Schema: public; Owner: trackit_user
--

CREATE SEQUENCE webuicontent_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.webuicontent_id_seq OWNER TO trackit_user;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 2846
-- Name: webuicontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trackit_user
--

ALTER SEQUENCE webuicontent_id_seq OWNED BY webuicontent.id;


--
-- TOC entry 3216 (class 2604 OID 59946)
-- Dependencies: 2840 2841 2841
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE commoncontent ALTER COLUMN id SET DEFAULT nextval('commoncontent_id_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 59947)
-- Dependencies: 2842 2843 2843
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- TOC entry 3322 (class 2604 OID 59948)
-- Dependencies: 2912 2911 2912
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE companyproperties ALTER COLUMN id SET DEFAULT nextval('companyproperty_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 59949)
-- Dependencies: 2909 2910 2910
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE companypropertytypes ALTER COLUMN id SET DEFAULT nextval('companypropertytype_id_seq'::regclass);


--
-- TOC entry 3295 (class 2604 OID 59950)
-- Dependencies: 2893 2894 2894
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE containermove ALTER COLUMN id SET DEFAULT nextval('gpsdata_id_seq'::regclass);


--
-- TOC entry 3309 (class 2604 OID 59951)
-- Dependencies: 2902 2901 2902
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE containers ALTER COLUMN id SET DEFAULT nextval('container_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 59952)
-- Dependencies: 2904 2903 2904
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE containertypes ALTER COLUMN id SET DEFAULT nextval('containertypes_id_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 59953)
-- Dependencies: 2892 2891 2892
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE containervsdevice ALTER COLUMN id SET DEFAULT nextval('trackvsdevice_id_seq'::regclass);


--
-- TOC entry 3317 (class 2604 OID 59954)
-- Dependencies: 2908 2907 2908
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- TOC entry 3221 (class 2604 OID 59955)
-- Dependencies: 2844 2845 2845
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE cultures ALTER COLUMN id SET DEFAULT nextval('cultures_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 59956)
-- Dependencies: 2885 2886 2886
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE devices ALTER COLUMN id SET DEFAULT nextval('sensors_id_seq'::regclass);


--
-- TOC entry 3290 (class 2604 OID 59957)
-- Dependencies: 2889 2890 2890
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE devicetypes ALTER COLUMN id SET DEFAULT nextval('devicetype_id_seq'::regclass);


--
-- TOC entry 3298 (class 2604 OID 59958)
-- Dependencies: 2896 2895 2896
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- TOC entry 3301 (class 2604 OID 59959)
-- Dependencies: 2897 2898 2898
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE eventtypes ALTER COLUMN id SET DEFAULT nextval('eventtypes_id_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 59960)
-- Dependencies: 2905 2906 2906
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE files ALTER COLUMN id SET DEFAULT nextval('files_id_seq'::regclass);


--
-- TOC entry 3264 (class 2604 OID 59961)
-- Dependencies: 2875 2874 2875
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE formatsdate ALTER COLUMN id SET DEFAULT nextval('formatsdate_id_seq'::regclass);


--
-- TOC entry 3262 (class 2604 OID 59962)
-- Dependencies: 2873 2872 2873
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE formatsdistance ALTER COLUMN id SET DEFAULT nextval('formatsmetrage_id_seq'::regclass);


--
-- TOC entry 3260 (class 2604 OID 59963)
-- Dependencies: 2871 2870 2871
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE formatstemperature ALTER COLUMN id SET DEFAULT nextval('formatstemperature_id_seq'::regclass);


--
-- TOC entry 3258 (class 2604 OID 59964)
-- Dependencies: 2869 2868 2869
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE formatstime ALTER COLUMN id SET DEFAULT nextval('formatstime_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 59965)
-- Dependencies: 2867 2866 2867
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE gpspoints ALTER COLUMN id SET DEFAULT nextval('gpspoints_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 59966)
-- Dependencies: 2864 2865 2865
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE iuservsiuser ALTER COLUMN id SET DEFAULT nextval('iuservsiuser_id_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 59967)
-- Dependencies: 2860 2861 2861
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE location ALTER COLUMN id SET DEFAULT nextval('realty_id_seq'::regclass);


--
-- TOC entry 3248 (class 2604 OID 59968)
-- Dependencies: 2859 2858 2859
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE locationvsuser ALTER COLUMN id SET DEFAULT nextval('realtyvsuser_id_seq'::regclass);


--
-- TOC entry 3252 (class 2604 OID 59969)
-- Dependencies: 2862 2863 2863
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 59970)
-- Dependencies: 2899 2900 2900
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE objecttypes ALTER COLUMN id SET DEFAULT nextval('objecttypes_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 59971)
-- Dependencies: 2856 2857 2857
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE routes ALTER COLUMN id SET DEFAULT nextval('routes_id_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 59972)
-- Dependencies: 2888 2887 2888
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE sensorsdata ALTER COLUMN id SET DEFAULT nextval('sensorsdata_id_seq'::regclass);


--
-- TOC entry 3275 (class 2604 OID 59973)
-- Dependencies: 2882 2881 2882
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE timezones ALTER COLUMN id SET DEFAULT nextval('"timezones_ID_seq"'::regclass);


--
-- TOC entry 3243 (class 2604 OID 59974)
-- Dependencies: 2854 2855 2855
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE trackcontrolcheckpoints ALTER COLUMN id SET DEFAULT nextval('trackcontrolcheckpoints_id_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 59975)
-- Dependencies: 2852 2853 2853
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE trackcontroltemperatures ALTER COLUMN id SET DEFAULT nextval('trackcontroltemperatures_id_seq'::regclass);


--
-- TOC entry 3268 (class 2604 OID 59976)
-- Dependencies: 2879 2880 2880
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE trackdates ALTER COLUMN id SET DEFAULT nextval('"TrackDates_ID_seq"'::regclass);


--
-- TOC entry 3239 (class 2604 OID 59977)
-- Dependencies: 2851 2850 2851
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE tracks ALTER COLUMN id SET DEFAULT nextval('tracks_id_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 59978)
-- Dependencies: 2884 2883 2884
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE trackstatuses ALTER COLUMN id SET DEFAULT nextval('trackstatuses_id_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 59979)
-- Dependencies: 2915 2916 2916
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE trackvsdevice ALTER COLUMN id SET DEFAULT nextval('trackvsdevice_id_seq1'::regclass);


--
-- TOC entry 3234 (class 2604 OID 59980)
-- Dependencies: 2849 2848 2849
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 3326 (class 2604 OID 59981)
-- Dependencies: 2917 2918 2918
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE usersenvironment ALTER COLUMN id SET DEFAULT nextval('userenvironment_id_seq'::regclass);


--
-- TOC entry 3266 (class 2604 OID 59982)
-- Dependencies: 2877 2876 2877
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE uservscompany ALTER COLUMN id SET DEFAULT nextval('uservscompany_id_seq'::regclass);


--
-- TOC entry 3224 (class 2604 OID 59983)
-- Dependencies: 2846 2847 2847
-- Name: id; Type: DEFAULT; Schema: public; Owner: trackit_user
--

ALTER TABLE webuicontent ALTER COLUMN id SET DEFAULT nextval('webuicontent_id_seq'::regclass);


--
-- TOC entry 3372 (class 2606 OID 18676)
-- Dependencies: 2882 2882
-- Name: TimeZones_PKey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY timezones
    ADD CONSTRAINT "TimeZones_PKey" PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 18660)
-- Dependencies: 2880 2880
-- Name: TrackDates_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY trackdates
    ADD CONSTRAINT "TrackDates_pkey" PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 18317)
-- Dependencies: 2841 2841
-- Name: commoncontent_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY commoncontent
    ADD CONSTRAINT commoncontent_pkey PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 18327)
-- Dependencies: 2843 2843
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- TOC entry 3414 (class 2606 OID 35325)
-- Dependencies: 2912 2912
-- Name: companyproperty_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY companyproperties
    ADD CONSTRAINT companyproperty_pkey PRIMARY KEY (id);


--
-- TOC entry 3410 (class 2606 OID 35304)
-- Dependencies: 2910 2910
-- Name: companypropertytype_key_key; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY companypropertytypes
    ADD CONSTRAINT companypropertytype_key_key UNIQUE (key);


--
-- TOC entry 3412 (class 2606 OID 35302)
-- Dependencies: 2910 2910
-- Name: companypropertytype_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY companypropertytypes
    ADD CONSTRAINT companypropertytype_pkey PRIMARY KEY (id);


--
-- TOC entry 3398 (class 2606 OID 26998)
-- Dependencies: 2902 2902
-- Name: container_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY containers
    ADD CONSTRAINT container_pkey PRIMARY KEY (id);


--
-- TOC entry 3400 (class 2606 OID 27007)
-- Dependencies: 2904 2904
-- Name: containertypes_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY containertypes
    ADD CONSTRAINT containertypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3406 (class 2606 OID 35282)
-- Dependencies: 2908 2908
-- Name: countries_key_key; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_key_key UNIQUE (key);


--
-- TOC entry 3408 (class 2606 OID 35280)
-- Dependencies: 2908 2908
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 18336)
-- Dependencies: 2845 2845
-- Name: cultures_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY cultures
    ADD CONSTRAINT cultures_pkey PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 18804)
-- Dependencies: 2890 2890
-- Name: devicetype_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY devicetypes
    ADD CONSTRAINT devicetype_pkey PRIMARY KEY (id);


--
-- TOC entry 3388 (class 2606 OID 26952)
-- Dependencies: 2896 2896
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 3390 (class 2606 OID 26964)
-- Dependencies: 2898 2898
-- Name: eventtypes_name_key; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY eventtypes
    ADD CONSTRAINT eventtypes_name_key UNIQUE (key);


--
-- TOC entry 3392 (class 2606 OID 26962)
-- Dependencies: 2898 2898
-- Name: eventtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY eventtypes
    ADD CONSTRAINT eventtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 35160)
-- Dependencies: 2906 2906
-- Name: files_guid_key; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_guid_key UNIQUE (guid);


--
-- TOC entry 3404 (class 2606 OID 35158)
-- Dependencies: 2906 2906
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- TOC entry 3366 (class 2606 OID 18542)
-- Dependencies: 2875 2875
-- Name: formatsdate_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY formatsdate
    ADD CONSTRAINT formatsdate_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 2606 OID 18533)
-- Dependencies: 2873 2873
-- Name: formatsmetrage_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY formatsdistance
    ADD CONSTRAINT formatsmetrage_pkey PRIMARY KEY (id);


--
-- TOC entry 3362 (class 2606 OID 18524)
-- Dependencies: 2871 2871
-- Name: formatstemperature_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY formatstemperature
    ADD CONSTRAINT formatstemperature_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 18515)
-- Dependencies: 2869 2869
-- Name: formatstime_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY formatstime
    ADD CONSTRAINT formatstime_pkey PRIMARY KEY (id);


--
-- TOC entry 3386 (class 2606 OID 18844)
-- Dependencies: 2894 2894
-- Name: gpsdata_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY containermove
    ADD CONSTRAINT gpsdata_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 18502)
-- Dependencies: 2867 2867
-- Name: gpspoints_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY gpspoints
    ADD CONSTRAINT gpspoints_pkey PRIMARY KEY (id);


--
-- TOC entry 3356 (class 2606 OID 18493)
-- Dependencies: 2865 2865
-- Name: iuservsiuser_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY iuservsiuser
    ADD CONSTRAINT iuservsiuser_pkey PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 18476)
-- Dependencies: 2863 2863
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 3394 (class 2606 OID 26989)
-- Dependencies: 2900 2900
-- Name: objecttypes_name_key; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY objecttypes
    ADD CONSTRAINT objecttypes_name_key UNIQUE (classname);


--
-- TOC entry 3396 (class 2606 OID 26987)
-- Dependencies: 2900 2900
-- Name: objecttypes_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY objecttypes
    ADD CONSTRAINT objecttypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 18468)
-- Dependencies: 2861 2861
-- Name: realty_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT realty_pkey PRIMARY KEY (id);


--
-- TOC entry 3350 (class 2606 OID 18458)
-- Dependencies: 2859 2859
-- Name: realtyvsuser_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY locationvsuser
    ADD CONSTRAINT realtyvsuser_pkey PRIMARY KEY (id);


--
-- TOC entry 3348 (class 2606 OID 18448)
-- Dependencies: 2857 2857
-- Name: routes_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- TOC entry 3378 (class 2606 OID 18760)
-- Dependencies: 2886 2886
-- Name: sensors_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT sensors_pkey PRIMARY KEY (id);


--
-- TOC entry 3380 (class 2606 OID 18770)
-- Dependencies: 2888 2888
-- Name: sensorsdata_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY sensorsdata
    ADD CONSTRAINT sensorsdata_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 18439)
-- Dependencies: 2855 2855
-- Name: trackcontrolcheckpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY trackcontrolcheckpoints
    ADD CONSTRAINT trackcontrolcheckpoints_pkey PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 18430)
-- Dependencies: 2853 2853
-- Name: trackcontroltemperatures_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY trackcontroltemperatures
    ADD CONSTRAINT trackcontroltemperatures_pkey PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 18627)
-- Dependencies: 2851 2851
-- Name: tracks_code_key; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_code_key UNIQUE (code);


--
-- TOC entry 3342 (class 2606 OID 18422)
-- Dependencies: 2851 2851
-- Name: tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 18739)
-- Dependencies: 2884 2884
-- Name: trackstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY trackstatuses
    ADD CONSTRAINT trackstatuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 18824)
-- Dependencies: 2892 2892
-- Name: trackvsdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY containervsdevice
    ADD CONSTRAINT trackvsdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 2606 OID 51818)
-- Dependencies: 2916 2916
-- Name: trackvsdevice_pkey1; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY trackvsdevice
    ADD CONSTRAINT trackvsdevice_pkey1 PRIMARY KEY (id);


--
-- TOC entry 3418 (class 2606 OID 59927)
-- Dependencies: 2918 2918
-- Name: userenvironment_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY usersenvironment
    ADD CONSTRAINT userenvironment_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 18397)
-- Dependencies: 2849 2849
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3368 (class 2606 OID 18615)
-- Dependencies: 2877 2877
-- Name: uservscompany_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY uservscompany
    ADD CONSTRAINT uservscompany_pkey PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 18349)
-- Dependencies: 2847 2847
-- Name: webuicontent_pkey; Type: CONSTRAINT; Schema: public; Owner: trackit_user; Tablespace: 
--

ALTER TABLE ONLY webuicontent
    ADD CONSTRAINT webuicontent_pkey PRIMARY KEY (id);


--
-- TOC entry 3327 (class 1259 OID 18687)
-- Dependencies: 2841
-- Name: commoncontent_classname; Type: INDEX; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE INDEX commoncontent_classname ON commoncontent USING btree (classname);


--
-- TOC entry 3328 (class 1259 OID 18693)
-- Dependencies: 2841
-- Name: commoncontent_cultureid_fk_index; Type: INDEX; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE INDEX commoncontent_cultureid_fk_index ON commoncontent USING btree (cultureid);


--
-- TOC entry 3375 (class 1259 OID 18815)
-- Dependencies: 2886
-- Name: fki_devicetypes_id; Type: INDEX; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE INDEX fki_devicetypes_id ON devices USING btree (devicetypeid);


--
-- TOC entry 3376 (class 1259 OID 18761)
-- Dependencies: 2886 2886
-- Name: sensors_id_serialnumber; Type: INDEX; Schema: public; Owner: trackit_user; Tablespace: 
--

CREATE INDEX sensors_id_serialnumber ON devices USING btree (id, serialnumber);


--
-- TOC entry 3419 (class 2606 OID 18688)
-- Dependencies: 2845 3333 2841
-- Name: commoncontent_cultureid_fk; Type: FK CONSTRAINT; Schema: public; Owner: trackit_user
--

ALTER TABLE ONLY commoncontent
    ADD CONSTRAINT commoncontent_cultureid_fk FOREIGN KEY (cultureid) REFERENCES cultures(id);


--
-- TOC entry 3423 (class 2606 OID 35326)
-- Dependencies: 2912 2843 3331
-- Name: companyproperty_companyid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trackit_user
--

ALTER TABLE ONLY companyproperties
    ADD CONSTRAINT companyproperty_companyid_fkey FOREIGN KEY (companyid) REFERENCES companies(id);


--
-- TOC entry 3424 (class 2606 OID 35331)
-- Dependencies: 2912 3411 2910
-- Name: companyproperty_propertytypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trackit_user
--

ALTER TABLE ONLY companyproperties
    ADD CONSTRAINT companyproperty_propertytypeid_fkey FOREIGN KEY (propertytypeid) REFERENCES companypropertytypes(id);


--
-- TOC entry 3422 (class 2606 OID 51768)
-- Dependencies: 3397 2902 2892
-- Name: containervsdevice_containerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trackit_user
--

ALTER TABLE ONLY containervsdevice
    ADD CONSTRAINT containervsdevice_containerid_fkey FOREIGN KEY (containerid) REFERENCES containers(id);


--
-- TOC entry 3420 (class 2606 OID 18810)
-- Dependencies: 3381 2890 2886
-- Name: devicetypes_id; Type: FK CONSTRAINT; Schema: public; Owner: trackit_user
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devicetypes_id FOREIGN KEY (devicetypeid) REFERENCES devicetypes(id);


--
-- TOC entry 3421 (class 2606 OID 18830)
-- Dependencies: 3377 2886 2892
-- Name: trackvsdevice_deviceid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trackit_user
--

ALTER TABLE ONLY containervsdevice
    ADD CONSTRAINT trackvsdevice_deviceid_fkey FOREIGN KEY (deviceid) REFERENCES devices(id);


--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 790
-- Name: pg_buffercache_pages(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION pg_buffercache_pages() FROM PUBLIC;
REVOKE ALL ON FUNCTION pg_buffercache_pages() FROM postgres;
GRANT ALL ON FUNCTION pg_buffercache_pages() TO postgres;


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 2829
-- Name: pg_buffercache; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pg_buffercache FROM PUBLIC;
REVOKE ALL ON TABLE pg_buffercache FROM postgres;
GRANT ALL ON TABLE pg_buffercache TO postgres;


--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 635
-- Name: pg_freespacemap_pages(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION pg_freespacemap_pages() FROM PUBLIC;
REVOKE ALL ON FUNCTION pg_freespacemap_pages() FROM postgres;
GRANT ALL ON FUNCTION pg_freespacemap_pages() TO postgres;


--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 2830
-- Name: pg_freespacemap_pages; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pg_freespacemap_pages FROM PUBLIC;
REVOKE ALL ON TABLE pg_freespacemap_pages FROM postgres;
GRANT ALL ON TABLE pg_freespacemap_pages TO postgres;


--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 634
-- Name: pg_freespacemap_relations(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION pg_freespacemap_relations() FROM PUBLIC;
REVOKE ALL ON FUNCTION pg_freespacemap_relations() FROM postgres;
GRANT ALL ON FUNCTION pg_freespacemap_relations() TO postgres;


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 2831
-- Name: pg_freespacemap_relations; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pg_freespacemap_relations FROM PUBLIC;
REVOKE ALL ON TABLE pg_freespacemap_relations FROM postgres;
GRANT ALL ON TABLE pg_freespacemap_relations TO postgres;


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 789
-- Name: dblink_connect_u(text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION dblink_connect_u(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION dblink_connect_u(text) FROM postgres;
GRANT ALL ON FUNCTION dblink_connect_u(text) TO postgres;


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 220
-- Name: dblink_connect_u(text, text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION dblink_connect_u(text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION dblink_connect_u(text, text) FROM postgres;
GRANT ALL ON FUNCTION dblink_connect_u(text, text) TO postgres;


-- Completed on 2009-06-02 21:17:20

--
-- PostgreSQL database dump complete
--

