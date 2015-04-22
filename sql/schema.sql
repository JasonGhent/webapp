-- tables
-- Table: files
CREATE TABLE files (
    id serial  NOT NULL,
    place_id int NOT NULL,
    created_by int  NOT NULL,
    moderated_by int,
    revision timestamp NOT NULL default now(),
    name text  NOT NULL,
    file_path text  NOT NULL,
    status text NOT NULL
);

-- Table: places
CREATE TABLE places (
    id serial  NOT NULL,
    created_by int  NOT NULL,
    moderated_by int,
    kml text  NOT NULL,
    place text  NOT NULL,
    revision timestamp NOT NULL default now(),
    state text,
    country text,
    foundation_minimum_square_feet int,
    adu_minimum_square_feet int,
    trailer_minimum_square_feet int,
    status text NOT NULL default 'review',
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

-- Values: roles
INSERT INTO roles(id, role) VALUES(1, 'manage_roles');
INSERT INTO roles(id, role) VALUES(2, 'manage_users');
INSERT INTO roles(id, role) VALUES(3, 'manage_places');

-- Values: users
INSERT INTO users(name, email) VALUES('System', 'noreply@tiny.house');

-- End of file.
