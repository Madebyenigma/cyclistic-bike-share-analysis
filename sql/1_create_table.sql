CREATE TABLE cyclistic.trips (
    trip_id VARCHAR(50),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    tripduration DOUBLE PRECISION,

    start_station_id BIGINT,
    start_station_name TEXT,

    end_station_id BIGINT,
    end_station_name TEXT,

    usertype VARCHAR(20),

    year INTEGER,
    month INTEGER,
    month_name VARCHAR(20),

    day INTEGER,
    day_of_week INTEGER,
    day_name VARCHAR(20),

    hour INTEGER,
    is_weekend BOOLEAN,

    tripduration_minutes DOUBLE PRECISION,
    tripduration_hours DOUBLE PRECISION
);