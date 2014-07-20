-- tables
-- Table: attachments
CREATE TABLE attachments (
    id serial  NOT NULL,
    user_id int  NOT NULL,
    revision date  NOT NULL,
    name text  NOT NULL,
    file_path text  NOT NULL,
    text text  NOT NULL,
    CONSTRAINT attachments_pk PRIMARY KEY (id)
);

-- Table: links
CREATE TABLE links (
    id serial  NOT NULL,
    user_id int  NOT NULL,
    place_id int  NOT NULL,
    revision date  NOT NULL,
    link text  NOT NULL,
    text text  NOT NULL,
    CONSTRAINT links_pk PRIMARY KEY (id)
);

-- Table: places
CREATE TABLE places (
    id serial  NOT NULL,
    kml text  NOT NULL,
    place text  NOT NULL,
    state text  NOT NULL,
    country text  NOT NULL,
    CONSTRAINT places_pk PRIMARY KEY (id)
);

-- Table: adu
CREATE TABLE adu (
    id serial  NOT NULL,
    place_id int  NOT NULL,
    revision date  NOT NULL,
    minimum_sqft int,
    maximum_sqft int,
    minimum_lot_sqft int,
    CONSTRAINT adu_pk PRIMARY KEY (id)
);

-- Table: foundation
CREATE TABLE foundation (
    id serial  NOT NULL,
    place_id int  NOT NULL,
    revision date  NOT NULL,
    minimum_sqft int,
    minimum_lot_sqft int,
    CONSTRAINT foundation_pk PRIMARY KEY (id)
);

-- Table: trailer
CREATE TABLE trailer (
    id serial  NOT NULL,
    place_id int  NOT NULL,
    revision date  NOT NULL,
    CONSTRAINT trailer_pk PRIMARY key (id)
);

-- Table: users
CREATE TABLE users (
    id serial  NOT NULL,
    name text NOT NULL,
    email text  NOT NULL,
    password text,
    token text,
    CONSTRAINT users_pk PRIMARY KEY (id)
);

-- Table: roles
CREATE TABLE roles (
    id serial NOT NULL,
    role text NOT NULL,
    CONSTRAINT roles_pk PRIMARY KEY (id)
);

-- Table: user_roles
CREATE TABLE user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    CONSTRAINT user_roles_pl PRIMARY KEY (user_id, role_id)
);

-- End of file.
