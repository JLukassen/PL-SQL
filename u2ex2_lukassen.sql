DECLARE
  v_count NUMBER;
  v_title mm_movie.movie_title%TYPE;
  v_movie_id NUMBER;
  v_step     NUMBER;
  v_value    NUMBER;
  rating     VARCHAR2(8);
  r_dump     VARCHAR2(8);
  r_low      VARCHAR2(8);
  r_mid      VARCHAR2(8);
  r_high     VARCHAR2(8);
  noRating   VARCHAR2(8);
BEGIN
  v_movie_id := 4;
  v_step     := 1;
  SELECT COUNT(*) INTO v_count FROM mm_movie WHERE movie_id = v_movie_id;
  v_step := 2;
  SELECT COUNT(*) INTO v_count FROM mm_rental WHERE movie_id = v_movie_id;
  CASE
  WHEN v_count <= 5 THEN
    rating     := 'r_dump';
  WHEN v_count <= 20 THEN
    rating     := 'r_low';
  WHEN v_count <= 35 THEN
    rating     := 'r_mid';
  WHEN v_count  > 35 THEN
    rating     := 'r_high';
  ELSE
    rating := 'noRating';
  END CASE;
  SELECT m.movie_title,
    COUNT(r.rental_id)
  INTO v_title,
    v_count
  FROM mm_movie m,
    mm_rental r
  WHERE m.movie_id = r.movie_id
  AND m.movie_id   = v_movie_id
  GROUP BY m.movie_title;
  DBMS_OUTPUT.PUT_LINE('For title '|| v_title || ' the count = ' || v_count || ' rating = ' || rating );
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('Movie ID '||v_movie_id||' was not found.');
END;