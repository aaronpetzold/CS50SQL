CREATE TABLE "passengers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL, 
    "last_name" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "check_ins" (
    "id" INTEGER,
    "passenger_id" INTEGER,
    "date" TEXT NOT NULL,
    "time" TEXT NOT NULL,
    "flight" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("passenger_id") REFERENCES "passengers"("id"),
    FOREIGN KEY("flight") REFERENCES "flights"("id")
);

CREATE TABLE "airlines" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "concourse" TEXT NOT NULL CHECK("concourse" IN ('A', 'B', 'C', 'D', 'E', 'F', 'T')),
    PRIMARY KEY("id")
);

CREATE TABLE "flights" (
    "id" INTEGER,
    "number" INTEGER NOT NULL,
    "airline" INTEGER,
    "departure_code" TEXT NOT NULL,
    "departure_date" TEXT NOT NULL,
    "departure_time" TEXT NOT NULL,
    "arrival_code" TEXT NOT NULL,
    "arrival_date" TEXT NOT NULL,
    "arrival_time" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("airline") REFERENCES "airlines"("id")
)