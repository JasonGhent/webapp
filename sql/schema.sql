-- tables
-- Table: attachments
CREATE TABLE attachments (
    id int  NOT NULL,
    user_id int  NOT NULL,
    revision date  NOT NULL,
    name text  NOT NULL,
    file_path text  NOT NULL,
    text text  NOT NULL,
    CONSTRAINT attachments_pk PRIMARY KEY (id)
);

-- Table: links
CREATE TABLE links (
    id int  NOT NULL,
    user_id int  NOT NULL,
    place_id int  NOT NULL,
    revision date  NOT NULL,
    link text  NOT NULL,
    text text  NOT NULL,
    CONSTRAINT links_pk PRIMARY KEY (id)
);

-- Table: places
CREATE TABLE places (
    id int  NOT NULL,
    user_id int  NOT NULL,
    revision date  NOT NULL,
    type text  NOT NULL,
    kml text  NOT NULL,
    minimum_house_sqft int  NOT NULL,
    minmum_lot_sqft int  NOT NULL,
    display_name text  NOT NULL,
    short_display_name text  NOT NULL,
    CONSTRAINT places_pk PRIMARY KEY (id)
);

-- Table: user
CREATE TABLE user (
    id int  NOT NULL,
    email text  NOT NULL,
    password text  NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (id)
);

-- End of file.
