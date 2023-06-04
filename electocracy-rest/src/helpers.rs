/// Convenient macro for comparing options with filter.
/// Diesel maps None to NULL, but in SQL NULL is never equal NULL.
/// In order to be able to compare NULL values correctly, this macro
/// translate `None` values to `is_null`, which is the correct way
/// to check for nullability in SQL.
macro_rules! filter_eq_nullable {
    ($query:expr, $table_field:expr, $val:expr) => {
        match $val {
            Some(ref val) => $query.filter($table_field.eq(val)).into_boxed(),
            None => $query.filter($table_field.is_null()).into_boxed(),
        }
    };
}

pub(crate) use filter_eq_nullable;
