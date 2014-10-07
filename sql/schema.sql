-- tables
-- Table: attachments
CREATE TABLE attachments (
    id serial  NOT NULL,
    user_id int  NOT NULL,
    revision timestamp NOT NULL default now(),
    name text  NOT NULL,
    file_path text  NOT NULL,
    approved bool,
    notes text
);

-- Table: places
CREATE TABLE places (
    id serial  NOT NULL,
    kml text  NOT NULL,
    place text  NOT NULL,
    revision timestamp NOT NULL default now(),
    state text,
    country text,
    foundation_minimum_square_feet int,
    adu_minimum_square_feet int,
    trailer_minimum_square_feet int,
    approved bool,
    notes text
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
