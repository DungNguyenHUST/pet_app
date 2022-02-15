SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    name character varying,
    image character varying,
    location character varying,
    website character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    size integer,
    overview text,
    time_establish timestamp without time zone,
    field_operetion character varying,
    time_start timestamp without time zone,
    time_end timestamp without time zone,
    country character varying,
    address character varying,
    policy text,
    phone character varying,
    "values" character varying,
    approved boolean DEFAULT false,
    slug character varying,
    wall_picture character varying,
    avatar character varying,
    working_time character varying,
    working_date character varying,
    company_type character varying,
    benefit text[] DEFAULT '{}'::text[],
    employer_id integer,
    tsv tsvector
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_apply_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_apply_jobs (
    id bigint NOT NULL,
    name text,
    email text,
    company_job_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cover_letter text,
    user_id integer,
    slug character varying,
    cover_vitate character varying,
    phone character varying,
    address character varying,
    process integer DEFAULT '-1'::integer
);


--
-- Name: company_apply_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_apply_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_apply_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_apply_jobs_id_seq OWNED BY public.company_apply_jobs.id;


--
-- Name: company_follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_follows (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id integer,
    user_id integer
);


--
-- Name: company_follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_follows_id_seq OWNED BY public.company_follows.id;


--
-- Name: company_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_images (
    id bigint NOT NULL,
    company_id integer,
    image character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: company_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_images_id_seq OWNED BY public.company_images.id;


--
-- Name: company_interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_interviews (
    id bigint NOT NULL,
    user_name character varying,
    "position" character varying,
    content character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id integer,
    difficultly integer,
    satisfied integer,
    process integer,
    offer boolean,
    get_interview character varying,
    "companyName" character varying,
    privacy boolean DEFAULT false,
    slug character varying,
    user_id integer
);


--
-- Name: company_interviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_interviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_interviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_interviews_id_seq OWNED BY public.company_interviews.id;


--
-- Name: company_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_jobs (
    id bigint NOT NULL,
    title character varying,
    description text,
    requirement text,
    benefit text,
    salary character varying,
    quantity character varying,
    category character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id integer,
    location character varying,
    level character varying,
    language character varying,
    date integer,
    dudate timestamp without time zone,
    end_date timestamp without time zone,
    typical character varying,
    approved boolean DEFAULT false,
    slug character varying,
    apply_another_site_flag boolean DEFAULT false,
    apply_site character varying,
    address character varying,
    skill text[] DEFAULT '{}'::text[],
    admin_id integer,
    detail character varying,
    salary_min integer,
    salary_max integer,
    company_name character varying,
    experience character varying,
    policy character varying,
    company_avatar character varying,
    employer_id integer,
    view_count integer,
    sponsor integer DEFAULT 0,
    urgent integer DEFAULT 0,
    tsv tsvector
);


--
-- Name: company_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_jobs_id_seq OWNED BY public.company_jobs.id;


--
-- Name: company_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_questions (
    id bigint NOT NULL,
    title character varying,
    content text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id integer,
    slug character varying,
    user_id integer,
    user_name character varying
);


--
-- Name: company_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_questions_id_seq OWNED BY public.company_questions.id;


--
-- Name: company_react_interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_react_interviews (
    id bigint NOT NULL,
    user_id integer,
    react_type integer DEFAULT '-1'::integer,
    company_interview_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: company_react_interviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_react_interviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_react_interviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_react_interviews_id_seq OWNED BY public.company_react_interviews.id;


--
-- Name: company_react_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_react_reviews (
    id bigint NOT NULL,
    user_id integer,
    react_type integer DEFAULT '-1'::integer,
    company_review_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: company_react_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_react_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_react_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_react_reviews_id_seq OWNED BY public.company_react_reviews.id;


--
-- Name: company_reply_interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_reply_interviews (
    id bigint NOT NULL,
    user_name character varying,
    reply_content character varying,
    company_interview_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    user_id integer
);


--
-- Name: company_reply_interviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_reply_interviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_reply_interviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_reply_interviews_id_seq OWNED BY public.company_reply_interviews.id;


--
-- Name: company_reply_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_reply_questions (
    id bigint NOT NULL,
    company_question_id integer,
    reply_content text,
    user_id integer,
    user_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying
);


--
-- Name: company_reply_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_reply_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_reply_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_reply_questions_id_seq OWNED BY public.company_reply_questions.id;


--
-- Name: company_reply_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_reply_reviews (
    id bigint NOT NULL,
    user_name character varying,
    reply_content character varying,
    company_review_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    user_id integer
);


--
-- Name: company_reply_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_reply_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_reply_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_reply_reviews_id_seq OWNED BY public.company_reply_reviews.id;


--
-- Name: company_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_reviews (
    id bigint NOT NULL,
    "companyName" character varying,
    score integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company_id integer,
    user_name character varying,
    review character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    "position" character varying,
    pros text,
    cons text,
    review_title text,
    career_score integer,
    manager_score integer,
    ot_score integer,
    salary_score integer,
    work_env_score integer,
    working_status boolean,
    average_score integer,
    privacy boolean DEFAULT false,
    working_time character varying,
    slug character varying,
    user_id integer,
    recommend boolean
);


--
-- Name: company_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_reviews_id_seq OWNED BY public.company_reviews.id;


--
-- Name: company_salaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_salaries (
    id bigint NOT NULL,
    company_id integer,
    salary integer,
    salary_currency character varying,
    salary_job character varying,
    salary_experience character varying,
    salary_working_status boolean,
    user_id integer,
    user_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    privacy boolean DEFAULT false,
    salary_bonus integer,
    level integer,
    "position" integer,
    locate integer
);


--
-- Name: company_salaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_salaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_salaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_salaries_id_seq OWNED BY public.company_salaries.id;


--
-- Name: company_save_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_save_jobs (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer,
    company_job_id integer
);


--
-- Name: company_save_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_save_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_save_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_save_jobs_id_seq OWNED BY public.company_save_jobs.id;


--
-- Name: cover_vitaes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cover_vitaes (
    id bigint NOT NULL,
    title character varying,
    description character varying,
    detail text,
    category character varying,
    language character varying,
    style character varying,
    avatar character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sample boolean DEFAULT false,
    user_id integer,
    origin_id integer,
    "primary" boolean DEFAULT false,
    slug character varying
);


--
-- Name: cover_vitaes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cover_vitaes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cover_vitaes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cover_vitaes_id_seq OWNED BY public.cover_vitaes.id;


--
-- Name: employer_bills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_bills (
    id bigint NOT NULL,
    employer_id bigint NOT NULL,
    bill_image character varying,
    confirmed boolean DEFAULT false,
    total_cash bigint DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: employer_bills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_bills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_bills_id_seq OWNED BY public.employer_bills.id;


--
-- Name: employer_costs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_costs (
    id bigint NOT NULL,
    employer_id bigint NOT NULL,
    location character varying,
    ip character varying,
    url character varying,
    cost bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: employer_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_costs_id_seq OWNED BY public.employer_costs.id;


--
-- Name: employer_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_notifications (
    id bigint NOT NULL,
    title character varying,
    content text,
    original_url character varying,
    trigger_user_id integer,
    readed boolean DEFAULT false,
    noti_type character varying,
    employer_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: employer_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_notifications_id_seq OWNED BY public.employer_notifications.id;


--
-- Name: employers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employers (
    id bigint NOT NULL,
    name character varying,
    avatar character varying,
    phone character varying,
    address character varying,
    company_name character varying,
    company_field character varying,
    company_id integer,
    approved boolean DEFAULT false,
    slug character varying,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    plan character varying,
    start_plan timestamp without time zone,
    end_plan timestamp without time zone,
    limit_cost bigint DEFAULT 0,
    remain_cost bigint DEFAULT 0,
    promotion_cost bigint DEFAULT 0,
    use_cost_seq integer DEFAULT 0,
    cost_status integer DEFAULT 0
);


--
-- Name: employers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employers_id_seq OWNED BY public.employers.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendly_id_slugs_id_seq OWNED BY public.friendly_id_slugs.id;


--
-- Name: post_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_comments (
    id bigint NOT NULL,
    user_name character varying,
    comment_content text,
    post_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    user_id integer
);


--
-- Name: post_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.post_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.post_comments_id_seq OWNED BY public.post_comments.id;


--
-- Name: post_reply_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_reply_comments (
    id bigint NOT NULL,
    user_name character varying,
    reply_content text,
    post_comment_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    user_id integer
);


--
-- Name: post_reply_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.post_reply_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_reply_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.post_reply_comments_id_seq OWNED BY public.post_reply_comments.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    username character varying,
    content text,
    title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    approved boolean DEFAULT false,
    slug character varying,
    avatar character varying,
    wall_picture character varying,
    category integer,
    user_id integer,
    tsv tsvector
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: problem_react_solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.problem_react_solutions (
    id bigint NOT NULL,
    user_id integer,
    react_type integer DEFAULT '-1'::integer,
    problem_solution_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: problem_react_solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.problem_react_solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_react_solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.problem_react_solutions_id_seq OWNED BY public.problem_react_solutions.id;


--
-- Name: problem_reply_solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.problem_reply_solutions (
    id bigint NOT NULL,
    user_name character varying,
    reply_content character varying,
    problem_solution_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    user_id integer
);


--
-- Name: problem_reply_solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.problem_reply_solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_reply_solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.problem_reply_solutions_id_seq OWNED BY public.problem_reply_solutions.id;


--
-- Name: problem_solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.problem_solutions (
    id bigint NOT NULL,
    user_name character varying,
    title character varying,
    content text,
    vote integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    problem_id integer,
    user_id integer,
    slug character varying
);


--
-- Name: problem_solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.problem_solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.problem_solutions_id_seq OWNED BY public.problem_solutions.id;


--
-- Name: problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.problems (
    id bigint NOT NULL,
    user_name character varying,
    title character varying,
    content text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    difficult character varying,
    category character varying,
    approved boolean DEFAULT false,
    slug character varying,
    user_id integer,
    tsv tsvector
);


--
-- Name: problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.problems_id_seq OWNED BY public.problems.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    user_id integer,
    target_type character varying,
    target_id integer,
    report_type integer,
    report_content text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scrap_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scrap_jobs (
    id bigint NOT NULL,
    company_id integer,
    company_name character varying,
    location character varying,
    url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    page_num integer,
    proxy boolean DEFAULT false,
    approved boolean DEFAULT false
);


--
-- Name: scrap_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scrap_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scrap_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scrap_jobs_id_seq OWNED BY public.scrap_jobs.id;


--
-- Name: scrap_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scrap_reviews (
    id bigint NOT NULL,
    company_id integer,
    company_name character varying,
    url character varying,
    raw_data text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    approved boolean DEFAULT false
);


--
-- Name: scrap_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scrap_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scrap_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scrap_reviews_id_seq OWNED BY public.scrap_reviews.id;


--
-- Name: user_adwards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_adwards (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    adward_name character varying,
    adward_summary character varying,
    receive_date timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tsv tsvector
);


--
-- Name: user_adwards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_adwards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_adwards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_adwards_id_seq OWNED BY public.user_adwards.id;


--
-- Name: user_certificates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_certificates (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    cert_name character varying,
    cert_summary character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tsv tsvector
);


--
-- Name: user_certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_certificates_id_seq OWNED BY public.user_certificates.id;


--
-- Name: user_educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_educations (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    cert_level character varying,
    cert_type character varying,
    school_level character varying,
    school_name character varying,
    school_location character varying,
    school_field character varying,
    enrolled boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tsv tsvector
);


--
-- Name: user_educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_educations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_educations_id_seq OWNED BY public.user_educations.id;


--
-- Name: user_experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_experiences (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    company_name character varying,
    company_location character varying,
    job_level character varying,
    job_summary character varying,
    enrolled boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tsv tsvector
);


--
-- Name: user_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_experiences_id_seq OWNED BY public.user_experiences.id;


--
-- Name: user_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title character varying,
    content text,
    original_url character varying,
    trigger_user_id integer,
    readed boolean DEFAULT false,
    noti_type character varying
);


--
-- Name: user_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_notifications_id_seq OWNED BY public.user_notifications.id;


--
-- Name: user_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_skills (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    skill_name character varying,
    skill_summary character varying,
    skill_level character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tsv tsvector
);


--
-- Name: user_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_skills_id_seq OWNED BY public.user_skills.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    picture character varying,
    password_digest character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    phone character varying,
    address character varying,
    cover_letter text,
    approved boolean DEFAULT false,
    slug character varying,
    wall_picture character varying,
    avatar character varying,
    cover_letter_attach character varying,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    provider character varying(50) DEFAULT ''::character varying NOT NULL,
    uid character varying(500) DEFAULT ''::character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    birthday timestamp without time zone,
    sex character varying,
    matrimony character varying,
    headline character varying,
    summary text,
    highest_education character varying,
    highest_career character varying,
    public boolean DEFAULT true,
    finding_job boolean DEFAULT true,
    tsv tsvector
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: action_text_rich_texts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_apply_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_apply_jobs ALTER COLUMN id SET DEFAULT nextval('public.company_apply_jobs_id_seq'::regclass);


--
-- Name: company_follows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_follows ALTER COLUMN id SET DEFAULT nextval('public.company_follows_id_seq'::regclass);


--
-- Name: company_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_images ALTER COLUMN id SET DEFAULT nextval('public.company_images_id_seq'::regclass);


--
-- Name: company_interviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_interviews ALTER COLUMN id SET DEFAULT nextval('public.company_interviews_id_seq'::regclass);


--
-- Name: company_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_jobs ALTER COLUMN id SET DEFAULT nextval('public.company_jobs_id_seq'::regclass);


--
-- Name: company_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_questions ALTER COLUMN id SET DEFAULT nextval('public.company_questions_id_seq'::regclass);


--
-- Name: company_react_interviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_react_interviews ALTER COLUMN id SET DEFAULT nextval('public.company_react_interviews_id_seq'::regclass);


--
-- Name: company_react_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_react_reviews ALTER COLUMN id SET DEFAULT nextval('public.company_react_reviews_id_seq'::regclass);


--
-- Name: company_reply_interviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reply_interviews ALTER COLUMN id SET DEFAULT nextval('public.company_reply_interviews_id_seq'::regclass);


--
-- Name: company_reply_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reply_questions ALTER COLUMN id SET DEFAULT nextval('public.company_reply_questions_id_seq'::regclass);


--
-- Name: company_reply_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reply_reviews ALTER COLUMN id SET DEFAULT nextval('public.company_reply_reviews_id_seq'::regclass);


--
-- Name: company_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews ALTER COLUMN id SET DEFAULT nextval('public.company_reviews_id_seq'::regclass);


--
-- Name: company_salaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_salaries ALTER COLUMN id SET DEFAULT nextval('public.company_salaries_id_seq'::regclass);


--
-- Name: company_save_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_save_jobs ALTER COLUMN id SET DEFAULT nextval('public.company_save_jobs_id_seq'::regclass);


--
-- Name: cover_vitaes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cover_vitaes ALTER COLUMN id SET DEFAULT nextval('public.cover_vitaes_id_seq'::regclass);


--
-- Name: employer_bills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_bills ALTER COLUMN id SET DEFAULT nextval('public.employer_bills_id_seq'::regclass);


--
-- Name: employer_costs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_costs ALTER COLUMN id SET DEFAULT nextval('public.employer_costs_id_seq'::regclass);


--
-- Name: employer_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_notifications ALTER COLUMN id SET DEFAULT nextval('public.employer_notifications_id_seq'::regclass);


--
-- Name: employers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employers ALTER COLUMN id SET DEFAULT nextval('public.employers_id_seq'::regclass);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('public.friendly_id_slugs_id_seq'::regclass);


--
-- Name: post_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_comments ALTER COLUMN id SET DEFAULT nextval('public.post_comments_id_seq'::regclass);


--
-- Name: post_reply_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reply_comments ALTER COLUMN id SET DEFAULT nextval('public.post_reply_comments_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: problem_react_solutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_react_solutions ALTER COLUMN id SET DEFAULT nextval('public.problem_react_solutions_id_seq'::regclass);


--
-- Name: problem_reply_solutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_reply_solutions ALTER COLUMN id SET DEFAULT nextval('public.problem_reply_solutions_id_seq'::regclass);


--
-- Name: problem_solutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_solutions ALTER COLUMN id SET DEFAULT nextval('public.problem_solutions_id_seq'::regclass);


--
-- Name: problems id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problems ALTER COLUMN id SET DEFAULT nextval('public.problems_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: scrap_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrap_jobs ALTER COLUMN id SET DEFAULT nextval('public.scrap_jobs_id_seq'::regclass);


--
-- Name: scrap_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrap_reviews ALTER COLUMN id SET DEFAULT nextval('public.scrap_reviews_id_seq'::regclass);


--
-- Name: user_adwards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_adwards ALTER COLUMN id SET DEFAULT nextval('public.user_adwards_id_seq'::regclass);


--
-- Name: user_certificates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_certificates ALTER COLUMN id SET DEFAULT nextval('public.user_certificates_id_seq'::regclass);


--
-- Name: user_educations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_educations ALTER COLUMN id SET DEFAULT nextval('public.user_educations_id_seq'::regclass);


--
-- Name: user_experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences ALTER COLUMN id SET DEFAULT nextval('public.user_experiences_id_seq'::regclass);


--
-- Name: user_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications ALTER COLUMN id SET DEFAULT nextval('public.user_notifications_id_seq'::regclass);


--
-- Name: user_skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_skills ALTER COLUMN id SET DEFAULT nextval('public.user_skills_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_apply_jobs company_apply_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_apply_jobs
    ADD CONSTRAINT company_apply_jobs_pkey PRIMARY KEY (id);


--
-- Name: company_follows company_follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_follows
    ADD CONSTRAINT company_follows_pkey PRIMARY KEY (id);


--
-- Name: company_images company_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_images
    ADD CONSTRAINT company_images_pkey PRIMARY KEY (id);


--
-- Name: company_interviews company_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_interviews
    ADD CONSTRAINT company_interviews_pkey PRIMARY KEY (id);


--
-- Name: company_jobs company_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_jobs
    ADD CONSTRAINT company_jobs_pkey PRIMARY KEY (id);


--
-- Name: company_questions company_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_questions
    ADD CONSTRAINT company_questions_pkey PRIMARY KEY (id);


--
-- Name: company_react_interviews company_react_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_react_interviews
    ADD CONSTRAINT company_react_interviews_pkey PRIMARY KEY (id);


--
-- Name: company_react_reviews company_react_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_react_reviews
    ADD CONSTRAINT company_react_reviews_pkey PRIMARY KEY (id);


--
-- Name: company_reply_interviews company_reply_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reply_interviews
    ADD CONSTRAINT company_reply_interviews_pkey PRIMARY KEY (id);


--
-- Name: company_reply_questions company_reply_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reply_questions
    ADD CONSTRAINT company_reply_questions_pkey PRIMARY KEY (id);


--
-- Name: company_reply_reviews company_reply_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reply_reviews
    ADD CONSTRAINT company_reply_reviews_pkey PRIMARY KEY (id);


--
-- Name: company_reviews company_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT company_reviews_pkey PRIMARY KEY (id);


--
-- Name: company_salaries company_salaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_salaries
    ADD CONSTRAINT company_salaries_pkey PRIMARY KEY (id);


--
-- Name: company_save_jobs company_save_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_save_jobs
    ADD CONSTRAINT company_save_jobs_pkey PRIMARY KEY (id);


--
-- Name: cover_vitaes cover_vitaes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cover_vitaes
    ADD CONSTRAINT cover_vitaes_pkey PRIMARY KEY (id);


--
-- Name: employer_bills employer_bills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_bills
    ADD CONSTRAINT employer_bills_pkey PRIMARY KEY (id);


--
-- Name: employer_costs employer_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_costs
    ADD CONSTRAINT employer_costs_pkey PRIMARY KEY (id);


--
-- Name: employer_notifications employer_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_notifications
    ADD CONSTRAINT employer_notifications_pkey PRIMARY KEY (id);


--
-- Name: employers employers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employers
    ADD CONSTRAINT employers_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: post_comments post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_pkey PRIMARY KEY (id);


--
-- Name: post_reply_comments post_reply_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reply_comments
    ADD CONSTRAINT post_reply_comments_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: problem_react_solutions problem_react_solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_react_solutions
    ADD CONSTRAINT problem_react_solutions_pkey PRIMARY KEY (id);


--
-- Name: problem_reply_solutions problem_reply_solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_reply_solutions
    ADD CONSTRAINT problem_reply_solutions_pkey PRIMARY KEY (id);


--
-- Name: problem_solutions problem_solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_solutions
    ADD CONSTRAINT problem_solutions_pkey PRIMARY KEY (id);


--
-- Name: problems problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problems
    ADD CONSTRAINT problems_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scrap_jobs scrap_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrap_jobs
    ADD CONSTRAINT scrap_jobs_pkey PRIMARY KEY (id);


--
-- Name: scrap_reviews scrap_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrap_reviews
    ADD CONSTRAINT scrap_reviews_pkey PRIMARY KEY (id);


--
-- Name: user_adwards user_adwards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_adwards
    ADD CONSTRAINT user_adwards_pkey PRIMARY KEY (id);


--
-- Name: user_certificates user_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_certificates
    ADD CONSTRAINT user_certificates_pkey PRIMARY KEY (id);


--
-- Name: user_educations user_educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_educations
    ADD CONSTRAINT user_educations_pkey PRIMARY KEY (id);


--
-- Name: user_experiences user_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences
    ADD CONSTRAINT user_experiences_pkey PRIMARY KEY (id);


--
-- Name: user_notifications user_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT user_notifications_pkey PRIMARY KEY (id);


--
-- Name: user_skills user_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_skills
    ADD CONSTRAINT user_skills_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_admins_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_confirmation_token ON public.admins USING btree (confirmation_token);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_unlock_token ON public.admins USING btree (unlock_token);


--
-- Name: index_companies_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_slug ON public.companies USING btree (slug);


--
-- Name: index_companies_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_tsv ON public.companies USING gin (tsv);


--
-- Name: index_company_apply_jobs_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_apply_jobs_on_slug ON public.company_apply_jobs USING btree (slug);


--
-- Name: index_company_interviews_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_interviews_on_slug ON public.company_interviews USING btree (slug);


--
-- Name: index_company_jobs_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_jobs_on_slug ON public.company_jobs USING btree (slug);


--
-- Name: index_company_jobs_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_jobs_on_tsv ON public.company_jobs USING gin (tsv);


--
-- Name: index_company_questions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_questions_on_slug ON public.company_questions USING btree (slug);


--
-- Name: index_company_react_interviews_on_company_interview_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_react_interviews_on_company_interview_id ON public.company_react_interviews USING btree (company_interview_id);


--
-- Name: index_company_react_reviews_on_company_review_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_react_reviews_on_company_review_id ON public.company_react_reviews USING btree (company_review_id);


--
-- Name: index_company_reply_interviews_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_reply_interviews_on_slug ON public.company_reply_interviews USING btree (slug);


--
-- Name: index_company_reply_questions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_reply_questions_on_slug ON public.company_reply_questions USING btree (slug);


--
-- Name: index_company_reply_reviews_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_reply_reviews_on_slug ON public.company_reply_reviews USING btree (slug);


--
-- Name: index_company_reviews_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_reviews_on_slug ON public.company_reviews USING btree (slug);


--
-- Name: index_company_salaries_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_company_salaries_on_slug ON public.company_salaries USING btree (slug);


--
-- Name: index_cover_vitaes_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cover_vitaes_on_slug ON public.cover_vitaes USING btree (slug);


--
-- Name: index_employer_bills_on_employer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_bills_on_employer_id ON public.employer_bills USING btree (employer_id);


--
-- Name: index_employer_costs_on_employer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_costs_on_employer_id ON public.employer_costs USING btree (employer_id);


--
-- Name: index_employer_notifications_on_employer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_notifications_on_employer_id ON public.employer_notifications USING btree (employer_id);


--
-- Name: index_employers_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_employers_on_confirmation_token ON public.employers USING btree (confirmation_token);


--
-- Name: index_employers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_employers_on_email ON public.employers USING btree (email);


--
-- Name: index_employers_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_employers_on_reset_password_token ON public.employers USING btree (reset_password_token);


--
-- Name: index_employers_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_employers_on_unlock_token ON public.employers USING btree (unlock_token);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type_and_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_type, sluggable_id);


--
-- Name: index_post_comments_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_post_comments_on_slug ON public.post_comments USING btree (slug);


--
-- Name: index_post_reply_comments_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_post_reply_comments_on_slug ON public.post_reply_comments USING btree (slug);


--
-- Name: index_posts_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_slug ON public.posts USING btree (slug);


--
-- Name: index_posts_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_tsv ON public.posts USING gin (tsv);


--
-- Name: index_problem_react_solutions_on_problem_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_react_solutions_on_problem_solution_id ON public.problem_react_solutions USING btree (problem_solution_id);


--
-- Name: index_problem_reply_solutions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_problem_reply_solutions_on_slug ON public.problem_reply_solutions USING btree (slug);


--
-- Name: index_problem_solutions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_problem_solutions_on_slug ON public.problem_solutions USING btree (slug);


--
-- Name: index_problems_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_problems_on_slug ON public.problems USING btree (slug);


--
-- Name: index_problems_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problems_on_tsv ON public.problems USING gin (tsv);


--
-- Name: index_user_adwards_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_adwards_on_tsv ON public.user_adwards USING gin (tsv);


--
-- Name: index_user_adwards_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_adwards_on_user_id ON public.user_adwards USING btree (user_id);


--
-- Name: index_user_certificates_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_certificates_on_tsv ON public.user_certificates USING gin (tsv);


--
-- Name: index_user_certificates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_certificates_on_user_id ON public.user_certificates USING btree (user_id);


--
-- Name: index_user_educations_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_educations_on_tsv ON public.user_educations USING gin (tsv);


--
-- Name: index_user_educations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_educations_on_user_id ON public.user_educations USING btree (user_id);


--
-- Name: index_user_experiences_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_experiences_on_tsv ON public.user_experiences USING gin (tsv);


--
-- Name: index_user_experiences_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_experiences_on_user_id ON public.user_experiences USING btree (user_id);


--
-- Name: index_user_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_notifications_on_user_id ON public.user_notifications USING btree (user_id);


--
-- Name: index_user_skills_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_skills_on_tsv ON public.user_skills USING gin (tsv);


--
-- Name: index_user_skills_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_skills_on_user_id ON public.user_skills USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_slug ON public.users USING btree (slug);


--
-- Name: index_users_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_tsv ON public.users USING gin (tsv);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: companies tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.companies FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'name');


--
-- Name: company_jobs tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.company_jobs FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'title', 'company_name', 'category', 'location', 'typical', 'level');


--
-- Name: posts tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'title');


--
-- Name: problems tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.problems FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'title');


--
-- Name: user_adwards tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.user_adwards FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'adward_name');


--
-- Name: user_certificates tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.user_certificates FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'cert_name');


--
-- Name: user_educations tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.user_educations FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'school_name', 'cert_type', 'school_level', 'school_field', 'cert_level');


--
-- Name: user_experiences tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.user_experiences FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'job_level', 'company_name');


--
-- Name: user_skills tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.user_skills FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'skill_name', 'skill_level');


--
-- Name: users tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv', 'pg_catalog.english', 'name', 'address', 'sex');


--
-- Name: user_certificates fk_rails_03b0a0c9d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_certificates
    ADD CONSTRAINT fk_rails_03b0a0c9d8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: company_react_interviews fk_rails_09ca32da16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_react_interviews
    ADD CONSTRAINT fk_rails_09ca32da16 FOREIGN KEY (company_interview_id) REFERENCES public.company_interviews(id);


--
-- Name: employer_bills fk_rails_337f65756f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_bills
    ADD CONSTRAINT fk_rails_337f65756f FOREIGN KEY (employer_id) REFERENCES public.employers(id);


--
-- Name: user_experiences fk_rails_3d2d7033d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences
    ADD CONSTRAINT fk_rails_3d2d7033d6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_adwards fk_rails_4619408ae8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_adwards
    ADD CONSTRAINT fk_rails_4619408ae8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: company_react_reviews fk_rails_5cec296d15; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_react_reviews
    ADD CONSTRAINT fk_rails_5cec296d15 FOREIGN KEY (company_review_id) REFERENCES public.company_reviews(id);


--
-- Name: problem_react_solutions fk_rails_8effeb822d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problem_react_solutions
    ADD CONSTRAINT fk_rails_8effeb822d FOREIGN KEY (problem_solution_id) REFERENCES public.problem_solutions(id);


--
-- Name: employer_notifications fk_rails_ab099dc775; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_notifications
    ADD CONSTRAINT fk_rails_ab099dc775 FOREIGN KEY (employer_id) REFERENCES public.employers(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: user_educations fk_rails_c8173aba95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_educations
    ADD CONSTRAINT fk_rails_c8173aba95 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_notifications fk_rails_cdbff2ee9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT fk_rails_cdbff2ee9e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: employer_costs fk_rails_e0b842c4e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_costs
    ADD CONSTRAINT fk_rails_e0b842c4e5 FOREIGN KEY (employer_id) REFERENCES public.employers(id);


--
-- Name: user_skills fk_rails_fe61b6a893; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_skills
    ADD CONSTRAINT fk_rails_fe61b6a893 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200402161924'),
('20200404041337'),
('20200405150609'),
('20200405163058'),
('20200406155937'),
('20200406160253'),
('20200406161719'),
('20200407095739'),
('20200407095824'),
('20200407105354'),
('20200407105444'),
('20200407110657'),
('20200408154818'),
('20200408155324'),
('20200416100106'),
('20200416100145'),
('20200416100227'),
('20200416100312'),
('20200416100342'),
('20200416100435'),
('20200416161840'),
('20200416161947'),
('20200416162027'),
('20200416162039'),
('20200419032404'),
('20200419103233'),
('20200419103334'),
('20200419105721'),
('20200419151951'),
('20200420083123'),
('20200420094646'),
('20200422045546'),
('20200422094543'),
('20200422094721'),
('20200422105345'),
('20200423045006'),
('20200423052016'),
('20200423104133'),
('20200423104903'),
('20200423104912'),
('20200423104919'),
('20200423104929'),
('20200423104939'),
('20200423105302'),
('20200531105433'),
('20200606100029'),
('20200606102854'),
('20200607093302'),
('20200607093335'),
('20200607093427'),
('20200620043511'),
('20200709162339'),
('20200713160917'),
('20200714160919'),
('20200714164746'),
('20200718034342'),
('20200922144910'),
('20200922145105'),
('20200922145135'),
('20200930154421'),
('20201113024403'),
('20201113064605'),
('20201113073353'),
('20201113074106'),
('20201113080352'),
('20201126062942'),
('20201215082328'),
('20201215095848'),
('20201216094915'),
('20201221091340'),
('20201221091405'),
('20210105034803'),
('20210112044125'),
('20210112044432'),
('20210112045523'),
('20210112045631'),
('20210112085427'),
('20210112085447'),
('20210112085543'),
('20210112090313'),
('20210113080731'),
('20210113081041'),
('20210113082504'),
('20210217043758'),
('20210217093532'),
('20210304083640'),
('20210304084742'),
('20210304084835'),
('20210304085134'),
('20210304091514'),
('20210309092727'),
('20210309092811'),
('20210309094421'),
('20210309095555'),
('20210309100546'),
('20210309100902'),
('20210309101320'),
('20210309101739'),
('20210309101901'),
('20210309102230'),
('20210309102247'),
('20210309102309'),
('20210309102330'),
('20210309102349'),
('20210309102421'),
('20210329153237'),
('20210331143647'),
('20210331143742'),
('20210331143828'),
('20210331143853'),
('20210331144325'),
('20210331144453'),
('20210331145858'),
('20210420104835'),
('20210423141254'),
('20210423141459'),
('20210423145543'),
('20210505101638'),
('20210505101755'),
('20210506070938'),
('20210506094526'),
('20210506103327'),
('20210507024643'),
('20210507092802'),
('20210511145444'),
('20210511145721'),
('20210511145744'),
('20210511145834'),
('20210511151948'),
('20210511152119'),
('20210511152429'),
('20210511152546'),
('20210511152744'),
('20210513071247'),
('20210513073258'),
('20210513073327'),
('20210513090427'),
('20210514023325'),
('20210514023523'),
('20210514032813'),
('20210514042335'),
('20210518023256'),
('20210518024357'),
('20210519074506'),
('20210519095647'),
('20210520034816'),
('20210523153407'),
('20210524040710'),
('20210524041522'),
('20210524042424'),
('20210524044607'),
('20210524045810'),
('20210524051234'),
('20210524063107'),
('20210524073442'),
('20210524075038'),
('20210524075129'),
('20210524075738'),
('20210724021842'),
('20210727150053'),
('20210730152952'),
('20210731055742'),
('20210803071304'),
('20210803093000'),
('20210805085537'),
('20210806024359'),
('20210809151321'),
('20210810023348'),
('20210817032653'),
('20210818033714'),
('20210818033732'),
('20210818033758'),
('20210818072729'),
('20210819085209'),
('20210820071042'),
('20210903095751'),
('20210903113113'),
('20210906035820'),
('20210910083140'),
('20210913074041'),
('20210913081843'),
('20210914082429'),
('20210915082501'),
('20210916101010'),
('20210917083731'),
('20210917145628'),
('20210919041841'),
('20210919045041'),
('20210919052041'),
('20210919052136'),
('20210920102649'),
('20211015094135'),
('20211016035614'),
('20211016041909'),
('20211016042803'),
('20211016042823'),
('20211016042833'),
('20211016044137'),
('20211016044148'),
('20211016044216'),
('20211016044229'),
('20211016044240'),
('20211022042854'),
('20211213032650'),
('20211213071116'),
('20211216042147'),
('20220214080327'),
('20220214104000');


