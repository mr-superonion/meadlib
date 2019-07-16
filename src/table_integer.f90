MODULE table_integer

   IMPLICIT NONE

   PRIVATE

   PUBLIC :: find_table_integer

CONTAINS

   INTEGER FUNCTION find_table_integer(x, xtab, n, imeth)

      ! Chooses between ways to find the integer location *below* some value in an array
      ! If x is within the table then the value returned will be between 1 and n-1
      ! If x is below the lower value of the array then 0 is returned (IMPORTANT)
      ! If x is above the upper value of the array then n is returned (IMPORTANT)
      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xtab(n)
      INTEGER, INTENT(IN) :: n
      INTEGER, INTENT(IN) :: imeth

      ! Methods (imeth)
      ! 1 - Get integer assuming the array has linear spacing
      ! 2 - Search array from first entry to last entry (often a silly thing to do)
      ! 3 - Mid-point search method to find integer (efficient for 2^n)

      IF (x < xtab(1)) THEN
         find_table_integer = 0
      ELSE IF (x > xtab(n)) THEN
         find_table_integer = n
      ELSE IF (imeth == 1) THEN
         find_table_integer = linear_table_integer(x, xtab, n)
      ELSE IF (imeth == 2) THEN
         find_table_integer = search_int(x, xtab, n)
      ELSE IF (imeth == 3) THEN
         find_table_integer = int_split(x, xtab, n)
      ELSE
         STOP 'TABLE INTEGER: Method specified incorrectly'
      END IF

   END FUNCTION find_table_integer

   INTEGER FUNCTION linear_table_integer(x, xtab, n)

      ! Assuming the table is exactly linear this gives you the integer position
      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xtab(n)
      INTEGER, INTENT(IN) :: n
      REAL :: x1, xn

      x1 = xtab(1)
      xn = xtab(n)
      linear_table_integer = 1+floor(real(n-1)*(x-x1)/(xn-x1))

   END FUNCTION linear_table_integer

   INTEGER FUNCTION search_int(x, xtab, n)

      ! Does a stupid search through the table from beginning to end to find integer
      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xtab(n)
      INTEGER, INTENT(IN) :: n
      INTEGER :: i

      IF (xtab(1) > xtab(n)) STOP 'SEARCH_INT: table in wrong order'

      DO i = 1, n
         IF (x >= xtab(i) .AND. x <= xtab(i+1)) EXIT
      END DO

      search_int = i

   END FUNCTION search_int

   INTEGER FUNCTION int_split(x, xtab, n)

      ! Finds the position of the value in the table by continually splitting it in half
      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xtab(n)
      INTEGER, INTENT(IN) :: n
      INTEGER :: i1, i2, imid

      IF (xtab(1) > xtab(n)) STOP 'INT_SPLIT: table in wrong order'

      i1 = 1
      i2 = n

      DO

         imid = nint((i1+i2)/2.)

         IF (x < xtab(imid)) THEN
            i2 = imid
         ELSE
            i1 = imid
         END IF

         IF (i2 == i1+1) EXIT

      END DO

      int_split = i1

   END FUNCTION int_split

END MODULE table_integer
