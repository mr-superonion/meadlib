MODULE special_functions

   USE constants

   IMPLICIT NONE

   PRIVATE

   ! Integer functions
   PUBLIC :: triangle_number
   PUBLIC :: factorial
   PUBLIC :: get_factorials
   PUBLIC :: Fibonacci
   PUBLIC :: get_Fibonaccis

   ! Real functions
   PUBLIC :: linear_polynomial
   PUBLIC :: quadratic_polynomial
   PUBLIC :: cubic_polynomial
   PUBLIC :: fix_linear
   PUBLIC :: fix_quadratic
   PUBLIC :: fix_cubic
   PUBLIC :: Legendre_polynomial
   PUBLIC :: Lagrange_polynomial
   PUBLIC :: Si
   PUBLIC :: Ci
   PUBLIC :: Bessel
   PUBLIC :: sinc
   PUBLIC :: wk_tophat
   PUBLIC :: wk_tophat_deriv
   PUBLIC :: wk_tophat_dderiv
   PUBLIC :: Gaussian
   PUBLIC :: lognormal
   PUBLIC :: uniform
   PUBLIC :: Rayleigh
   PUBLIC :: Poisson
   PUBLIC :: exponential
   PUBLIC :: Lorentzian
   PUBLIC :: polynomial
   PUBLIC :: Rosenbrock
   PUBLIC :: Himmelblau

   ! Silly functions
   PUBLIC :: apodise
   PUBLIC :: smooth_apodise
   PUBLIC :: blob
   PUBLIC :: smooth_blob
   PUBLIC :: sigmoid_tanh
   PUBLIC :: sigmoid_log

CONTAINS

   REAL FUNCTION linear_polynomial(x, a1, a0)

      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: a1
      REAL, INTENT(IN) :: a0

      linear_polynomial = a1*x + a0

   END FUNCTION linear_polynomial

   REAL FUNCTION quadratic_polynomial(x, a2, a1, a0)

      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: a2
      REAL, INTENT(IN) :: a1
      REAL, INTENT(IN) :: a0

      quadratic_polynomial = a2*x**2 + a1*x + a0

   END FUNCTION quadratic_polynomial

   REAL FUNCTION cubic_polynomial(x, a3, a2, a1, a0)

      IMPLICIT NONE
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: a3
      REAL, INTENT(IN) :: a2
      REAL, INTENT(IN) :: a1
      REAL, INTENT(IN) :: a0

      cubic_polynomial = a3*x**3 + a2*x**2 + a1*x + a0

   END FUNCTION cubic_polynomial

   SUBROUTINE fix_linear(a1, a0, x1, y1, x2, y2)

      ! Given xi, yi i=1,2 fixes a line between these points
      REAL, INTENT(OUT) :: a1
      REAL, INTENT(OUT) :: a0 
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: y1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: y2

      a1 = (y2-y1)/(x2-x1)
      a0 = y1-a1*x1

   END SUBROUTINE fix_linear

   SUBROUTINE fix_quadratic(a2, a1, a0, x1, y1, x2, y2, x3, y3)

      ! Given xi, yi i=1,2,3 fixes a quadratic between these points
      REAL, INTENT(OUT) :: a2
      REAL, INTENT(OUT) :: a1
      REAL, INTENT(OUT) :: a0
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: y1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: y2
      REAL, INTENT(IN) :: x3
      REAL, INTENT(IN) :: y3

      a2 = ((y2-y1)/(x2-x1)-(y3-y1)/(x3-x1))/(x2-x3)
      a1 = (y2-y1)/(x2-x1)-a2*(x2+x1)
      a0 = y1-a2*(x1**2.)-a1*x1

   END SUBROUTINE fix_quadratic

   SUBROUTINE fix_cubic(a3, a2, a1, a0, x1, y1, x2, y2, x3, y3, x4, y4)

      ! Given xi, yi i=1,2,3,4 fixes a cubic between these points
      REAL, INTENT(OUT) :: a3
      REAL, INTENT(OUT) :: a2
      REAL, INTENT(OUT) :: a1
      REAL, INTENT(OUT) :: a0
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: y1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: y2
      REAL, INTENT(IN) :: x3
      REAL, INTENT(IN) :: y3
      REAL, INTENT(IN) :: x4
      REAL, INTENT(IN) :: y4
      REAL :: f1, f2, f3

      f1 = (y4-y1)/((x4-x2)*(x4-x1)*(x4-x3))
      f2 = (y3-y1)/((x3-x2)*(x3-x1)*(x4-x3))
      f3 = (y2-y1)/((x2-x1)*(x4-x3))*(1./(x4-x2)-1./(x3-x2))

      a3 = f1-f2-f3

      f1 = (y3-y1)/((x3-x2)*(x3-x1))
      f2 = (y2-y1)/((x2-x1)*(x3-x2))
      f3 = a3*(x3+x2+x1)

      a2 = f1-f2-f3

      f1 = (y4-y1)/(x4-x1)
      f2 = a3*(x4**2.+x4*x1+x1**2.)
      f3 = a2*(x4+x1)

      a1 = f1-f2-f3

      a0 = y1-a3*x1**3.-a2*x1**2.-a1*x1

   END SUBROUTINE fix_cubic

   INTEGER FUNCTION triangle_number(n)

      ! Calculates the nth triangle number
      ! T(1) = 1, T(2) = 3, T(3) = 6, T(4) = 10, ..., T(n)=(1/2)*n*(n+1)
      INTEGER, INTENT(IN) :: n

      triangle_number = n*(n+1)/2

   END FUNCTION triangle_number

   SUBROUTINE get_Fibonaccis(F, n)

      ! Provides a sequence of the first n Fibonacci numbers
      ! F(0)=0 is not provided
      ! F(1)=1; F(2)=1; F(3)=2; F(4)=3; ...; F(n)=F(n-1)+F(n-2)
      INTEGER, INTENT(OUT) :: F(:)
      INTEGER, INTENT(IN) :: n   
      INTEGER :: i

      IF (size(F) /= n) STOP 'GET_FIBONACCIS: Error, F should be of size n'

      IF (n <= 0) THEN
         STOP 'GET_FIBONACCIS: Error, this cannot be called for n<=0'
      ELSE
         DO i = 1, n
            IF (i == 1 .OR. i == 2) THEN
               F(i) = 1
            ELSE
               F(i) = F(i-1)+F(i-2)
            END IF
         END DO
      END IF

   END SUBROUTINE get_Fibonaccis

   INTEGER FUNCTION Fibonacci(n)

      ! Returns the nth Fibonacci number
      ! F(0)=0, F(1)=1, F(2)=1, F(3)=2, F(4)=3, ..., F(n)=F(n-1)+F(n-2)
      INTEGER, INTENT(IN) :: n
      INTEGER :: F(n)

      IF (n < 0) THEN
         STOP 'FIBONACCI: Error, Fibonacci numbers undefined for n<0'
      ELSE IF (n == 0) THEN
         Fibonacci = 0
      ELSE
         CALL get_Fibonaccis(F, n)
         Fibonacci = F(n)
      END IF

   END FUNCTION Fibonacci

   SUBROUTINE get_factorials(f, n)

      ! Provides a sequence of factorial numbers up to n
      ! f(0)=1 is not provided
      ! f(1)=1, f(2)=2, f(3)=6, f(4)=24, ..., f(n)=n*f(n-1)
      ! TODO: Should this really be INT8 here?    
      USE precision 
      INTEGER(i8), INTENT(OUT) :: f(:)
      INTEGER, INTENT(IN) :: n
      INTEGER :: i

      IF (size(f) /= n) STOP 'GET_FIBONACCIS: Error, F should be of size n'

      IF (n <= 0) THEN
         STOP 'GET_FACTORIALS: Error, this cannot be called for n<=0'
      ELSE
         DO i = 1, n
            IF (i == 1) THEN
               f(i) = 1
            ELSE
               f(i) = i*f(i-1)
            END IF
         END DO
      END IF

   END SUBROUTINE get_factorials

   INTEGER(i8) FUNCTION factorial(n)

      ! Calculates the nth factorial number
      USE precision
      INTEGER, INTENT(IN) :: n
      INTEGER(i8) :: f8(n)

      IF (n < 0) THEN
         STOP 'FACTORIAL: Error, factorials not defined for n<0'
      ELSE IF (n == 0) THEN
         factorial = 1
      ELSE
         CALL get_factorials(f8, n)
         !factorial=INT(f8(n))
         factorial = f8(n)
      END IF

   END FUNCTION factorial

   REAL FUNCTION sigmoid_tanh(x)

      ! A function that smoothly transitions from 0 to 1 around x
      REAL, INTENT(IN) :: x

      sigmoid_tanh = 0.5*(1.+tanh(x))

   END FUNCTION sigmoid_tanh

   REAL FUNCTION sigmoid_log(x, a)

      ! A function that smoothly transitions from 0 to 1 around x
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: a
      REAL :: xp, xm

      xp = x**a
      xm = x**(-a)

      sigmoid_log = 0.5*(1.+(xp-xm)/(xp+xm))

   END FUNCTION sigmoid_log

   REAL FUNCTION Legendre_Polynomial(n, x)

      ! Returns the nth order Legendre polynomail: P_n(x)
      REAL, INTENT(IN) :: x
      INTEGER, INTENT(IN) :: n

      IF (n == 0) THEN
         Legendre_Polynomial = 1.
      ELSE IF (n == 1) THEN
         Legendre_Polynomial = x
      ELSE IF (n == 2) THEN
         Legendre_Polynomial = (3.*x**2-1.)/2.
      ELSE IF (n == 3) THEN
         Legendre_Polynomial = (5.*x**3-3.*x)/2.
      ELSE IF (n == 4) THEN
         Legendre_Polynomial = (35.*x**4-30.*x**2+3.)/8.
      ELSE
         STOP 'LEGENDRE_POLYNOMIAL: polynomial of this order not stored'
      END IF

   END FUNCTION Legendre_Polynomial

   REAL FUNCTION Lagrange_polynomial(x, n, xv, yv)

      ! Computes the result of the nth order Lagrange polynomial at point x, L(x)
      REAL, INTENT(IN) :: x
      INTEGER, INTENT(IN) :: n
      REAL, INTENT(IN) :: xv(n+1)
      REAL, INTENT(IN) :: yv(n+1)
      REAL :: l(n+1)     
      INTEGER :: i, j

      IF (n == 0) THEN
         Lagrange_polynomial = yv(1)
      ELSE IF (n == 1) THEN
         Lagrange_polynomial = Lagrange_polynomial_1(x, xv, yv)
      ELSE IF (n == 2) THEN
         Lagrange_polynomial = Lagrange_polynomial_2(x, xv, yv)
      ELSE IF (n == 3) THEN
         Lagrange_polynomial = Lagrange_polynomial_3(x, xv, yv)
      ELSE

         ! Initialise variables, one for sum and one for multiplication
         Lagrange_polynomial = 0.
         l = 1.

         ! Loops to find the polynomials, one is a sum and one is a multiple
         DO i = 0, n
            DO j = 0, n
               IF (i .NE. j) l(i+1) = l(i+1)*(x-xv(j+1))/(xv(i+1)-xv(j+1))
            END DO
            Lagrange_polynomial = Lagrange_polynomial+l(i+1)*yv(i+1)
         END DO

      END IF

   END FUNCTION Lagrange_polynomial

   REAL FUNCTION Lagrange_polynomial_1(x, xv, yv)

      ! Dedicated function for linear interpolation polynomial
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xv(2)
      REAL, INTENT(IN) :: yv(2)
      REAL :: x01, x02
      REAL :: x12
      REAL :: f1, f2

      x01 = x-xv(1)
      x02 = x-xv(2)

      x12 = xv(1)-xv(2)

      f1 = x02*yv(1)
      f2 = x01*yv(2)

      Lagrange_polynomial_1 = (f1-f2)/x12

   END FUNCTION Lagrange_polynomial_1

   REAL FUNCTION Lagrange_polynomial_2(x, xv, yv)

      ! Dedicated function for quadratic interpolation polynomial
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xv(3)
      REAL, INTENT(IN) :: yv(3)
      REAL :: x01, x02, x03
      REAL :: x12, x13, x23
      REAL :: f1, f2, f3

      x01 = x-xv(1)
      x02 = x-xv(2) 
      x03 = x-xv(3)

      x12 = xv(1)-xv(2)
      x13 = xv(1)-xv(3)
      x23 = xv(2)-xv(3)

      f1 = yv(1)*x02*x03/(x12*x13)
      f2 = x01*yv(2)*x03/(x12*x23)
      f3 = x01*x02*yv(3)/(x13*x23)

      Lagrange_polynomial_2 = f1-f2+f3

   END FUNCTION Lagrange_polynomial_2

   REAL FUNCTION Lagrange_polynomial_3(x, xv, yv)

      ! Dedicated function for cubic interpolation polynomial
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: xv(4)
      REAL, INTENT(IN) :: yv(4)
      REAL :: x01, x02, x03, x04
      REAL :: x12, x13, x14, x23, x24, x34
      REAL :: f1, f2, f3, f4

      x01 = x-xv(1)
      x02 = x-xv(2) 
      x03 = x-xv(3)
      x04 = x-xv(4)

      x12 = xv(1)-xv(2)
      x13 = xv(1)-xv(3)
      x14 = xv(1)-xv(4)
      x23 = xv(2)-xv(3)
      x24 = xv(2)-xv(4)
      x34 = xv(3)-xv(4)

      f1 = yv(1)*x02*x03*x04/(x12*x13*x14)
      f2 = x01*yv(2)*x03*x04/(x12*x23*x24)
      f3 = x01*x02*yv(3)*x04/(x13*x23*x34)
      f4 = x01*x02*x03*yv(4)/(x14*x24*x34)

      Lagrange_polynomial_3 = f1-f2+f3-f4

   END FUNCTION Lagrange_polynomial_3

   REAL FUNCTION sinc(x)

      ! sinc function: sin(x)/x
      ! TODO: Is the Taylor expansion here unnecessary?
      REAL, INTENT(IN) :: x
      REAL, PARAMETER :: dx = 1e-3 ! small |x| below which to use Taylor expansion

      IF (abs(x) < dx) THEN
         sinc = 1.-(x**2)/6.+(x**4)/120.
      ELSE
         sinc = sin(x)/x
      END IF

   END FUNCTION sinc

   REAL FUNCTION wk_tophat(x)

      ! The normlaised Fourier Transform of a spherical top-hat
      REAL, INTENT(IN) :: x
      REAL, PARAMETER :: dx = 1e-3 ! Taylor expansion for |x|<dx

      ! Taylor expansion used for low x to avoid cancelation problems
      IF (abs(x) < dx) THEN
         wk_tophat = 1.-x**2/10.
      ELSE
         wk_tophat = (3./x**3)*(sin(x)-x*cos(x))
      END IF

   END FUNCTION wk_tophat

   REAL FUNCTION wk_tophat_deriv(x)

      ! The derivative of a normlaised Fourier Transform of a spherical top-hat
      REAL, INTENT(IN) :: x
      REAL, PARAMETER :: dx = 1e-3 ! Taylor expansion for |x|<dx

      ! Taylor expansion used for low x to avoid cancelation problems
      IF (abs(x) < dx) THEN
         wk_tophat_deriv = -x/5.+x**3/70.
      ELSE
         wk_tophat_deriv = (3./x**4)*((x**2-3.)*sin(x)+3.*x*cos(x))
      END IF

   END FUNCTION wk_tophat_deriv

   REAL FUNCTION wk_tophat_dderiv(x)

      ! The second derivative of a normlaised Fourier Transform of a spherical top-hat
      REAL, INTENT(IN) :: x
      REAL, PARAMETER :: dx = 1e-3 ! Taylor expansion for |x|<dx

      ! Taylor expansion used for low x to avoid cancelation problems
      IF (abs(x) < dx) THEN
         wk_tophat_dderiv = -0.2+3.*x**2/70.
      ELSE
         wk_tophat_dderiv = (3./x**5)*((12.-5.*x**2)*sin(x)+x*(x**2-12.)*cos(x))
      END IF

   END FUNCTION wk_tophat_dderiv

   REAL FUNCTION apodise(x, x1, x2, n)

      ! Apodises a function between x1 and x2
      ! Goes to one smoothly at x1
      ! Goes to zero linearly at x2, so the gradient change is discontinous
      ! n govenrns the severity of the transition
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: n

      IF (n <= 0.) STOP 'APODISE: Error, n must be greater than zero'

      IF (x < x1) THEN
         apodise = 1.
      ELSE IF (x > x2) THEN
         apodise = 0.
      ELSE
         apodise = cos((pi/2.)*(x-x1)/(x2-x1))
         apodise = apodise**n
      END IF

   END FUNCTION apodise

   REAL FUNCTION smooth_apodise(x, x1, x2, n)

      ! Apodises a function between x1 and x2
      ! Goes to one smoothly at x1 and zero smoothly at x2
      ! n govenrns the severity of the transition
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: n

      IF (n <= 0.) STOP 'APODISE: Error, n must be greater than zero'

      IF (x < x1) THEN
         smooth_apodise = 1.
      ELSE IF (x > x2) THEN
         smooth_apodise = 0.
      ELSE
         smooth_apodise = 0.5*(1.+cos(pi*(x-x1)/(x2-x1)))
         smooth_apodise = smooth_apodise**n
      END IF

   END FUNCTION smooth_apodise

   REAL FUNCTION blob(x, x1, x2, n)

      ! Makes a blob between x1 and x2, with zero elsewhere
      ! Blob goes to zero linearly at x1 and x2, so the gradient change is discontinous
      ! n governs the severity (blobiness) of the blob
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: n

      IF (n <= 0.) STOP 'APODISE: Error, n must be greater than zero'

      IF (x < x1) THEN
         blob = 0.
      ELSE IF (x > x2) THEN
         blob = 0.
      ELSE
         blob = sin(pi*(x-x1)/(x2-x1))
         blob = blob**n
      END IF

   END FUNCTION blob

   REAL FUNCTION smooth_blob(x, x1, x2, n)

      ! Makes a blob between x1 and x2, with zero elsewhere
      ! Blob goes to zero smoothly at x1 and x2
      ! n governs the severity (blobiness) of the blob
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: x1
      REAL, INTENT(IN) :: x2
      REAL, INTENT(IN) :: n

      IF (n <= 0.) STOP 'APODISE: Error, n must be greater than zero'

      IF (x < x1) THEN
         smooth_blob = 0.
      ELSE IF (x > x2) THEN
         smooth_blob = 0.
      ELSE
         smooth_blob = (1.+cos(twopi*(x-x1)/(x2-x1)))/2.
         smooth_blob = (1.-smooth_blob)**n
      END IF

   END FUNCTION smooth_blob

   REAL FUNCTION Si(x)

      ! Returns the 'sine integral' function: Si(x)=int_0^x sin(t)/t dt
      USE precision
      REAL, INTENT(IN) :: x
      REAL(dp) :: x2, y, f, g, si8
      REAL, PARAMETER :: x0 = 4. ! Transition between two different approximations

      ! Expansions for high and low x thieved from Wikipedia, two different expansions for above and below 4.
      IF (abs(x) <= x0) THEN

         x2 = x*x

         si8 = x*(1.d0+x2*(-4.54393409816329991d-2+x2*(1.15457225751016682d-3 &
               +x2*(-1.41018536821330254d-5+x2*(9.43280809438713025d-8+x2*(-3.53201978997168357d-10 &
               +x2*(7.08240282274875911d-13+x2*(-6.05338212010422477d-16))))))))/ &
               (1.+x2*(1.01162145739225565d-2+x2*(4.99175116169755106d-5+ &
               x2*(1.55654986308745614d-7+x2*(3.28067571055789734d-10+x2*(4.5049097575386581d-13 &
               +x2*(3.21107051193712168d-16)))))))

         Si = real(si8)

      ELSE IF (abs(x) > x0) THEN

         y = 1.d0/(x*x)

         f = (1.d0+y*(7.44437068161936700618d2+y*(1.96396372895146869801d5+ &
               y*(2.37750310125431834034d7+y*(1.43073403821274636888d9+y*(4.33736238870432522765d10 &
               +y*(6.40533830574022022911d11+y*(4.20968180571076940208d12+ &
               y*(1.00795182980368574617d13+y*(4.94816688199951963482d12+ &
               y*(-4.94701168645415959931d11)))))))))))/(x*(1.+y*(7.46437068161927678031d2+ &
               y*(1.97865247031583951450d5+y*(2.41535670165126845144d7+ &
               y*(1.47478952192985464958d9+y*(4.58595115847765779830d10+ &
               y*(7.08501308149515401563d11+y*(5.06084464593475076774d12+ &
               y*(1.43468549171581016479d13+y*(1.11535493509914254097d13)))))))))))

         g = y*(1.d0+y*(8.1359520115168615d2+y*(2.35239181626478200d5+ &
               y*(3.12557570795778731d7+y*(2.06297595146763354d9+y*(6.83052205423625007d10+ &
               y*(1.09049528450362786d12+y*(7.57664583257834349d12+y*(1.81004487464664575d13+ &
               y*(6.43291613143049485d12+y*(-1.36517137670871689d12)))))))))))/ &
               (1.+y*(8.19595201151451564d2+y*(2.40036752835578777d5+y*(3.26026661647090822d7 &
               +y*(2.23355543278099360d9+y*(7.87465017341829930d10+y*(1.39866710696414565d12 &
               +y*(1.17164723371736605d13+y*(4.01839087307656620d13+y*(3.99653257887490811d13))))))))))

         Si = real(pi/2.d0-f*cos(x)-g*sin(x))

      ELSE

         STOP 'SI: Something went very wrong'

      END IF

   END FUNCTION Si

   REAL FUNCTION Ci(x)

      ! Returns the 'cosine integral' function Ci(x): -int_x^inf cos(t)/t dt
      USE precision
      REAL, INTENT(IN) :: x
      REAL(dp) :: x2, y, f, g, ci8
      REAL, PARAMETER :: x0 = 4. ! Transition between two different approximations

      ! Expansions for high and low x thieved from Wikipedia, two different expansions for above and below 4.
      IF (abs(x) <= x0) THEN

         x2 = x*x

         ci8 = em+log(x)+x2*(-0.25d0+x2*(7.51851524438898291d-3+x2*(-1.27528342240267686d-4 &
               +x2*(1.05297363846239184d-6+x2*(-4.68889508144848019d-9+x2*(1.06480802891189243d-11 &
               +x2*(-9.93728488857585407d-15)))))))/(1.+x2*(1.1592605689110735d-2+ &
               x2*(6.72126800814254432d-5+x2*(2.55533277086129636d-7+x2*(6.97071295760958946d-10+ &
               x2*(1.38536352772778619d-12+x2*(1.89106054713059759d-15+x2*(1.39759616731376855d-18))))))))

         Ci = real(ci8)

      ELSE IF (abs(x) > x0) THEN

         y = 1./(x*x)

         f = (1.d0+y*(7.44437068161936700618d2+y*(1.96396372895146869801d5+ &
               y*(2.37750310125431834034d7+y*(1.43073403821274636888d9+y*(4.33736238870432522765d10 &
               +y*(6.40533830574022022911d11+y*(4.20968180571076940208d12+y*(1.00795182980368574617d13 &
               +y*(4.94816688199951963482d12+y*(-4.94701168645415959931d11)))))))))))/ &
               (x*(1.+y*(7.46437068161927678031d2+y*(1.97865247031583951450d5+ &
               y*(2.41535670165126845144d7+y*(1.47478952192985464958d9+ &
               y*(4.58595115847765779830d10+y*(7.08501308149515401563d11+y*(5.06084464593475076774d12 &
               +y*(1.43468549171581016479d13+y*(1.11535493509914254097d13)))))))))))

         g = y*(1.d0+y*(8.1359520115168615d2+y*(2.35239181626478200d5+y*(3.12557570795778731d7 &
               +y*(2.06297595146763354d9+y*(6.83052205423625007d10+ &
               y*(1.09049528450362786d12+y*(7.57664583257834349d12+ &
               y*(1.81004487464664575d13+y*(6.43291613143049485d12+y*(-1.36517137670871689d12))))))))))) &
               /(1.+y*(8.19595201151451564d2+y*(2.40036752835578777d5+ &
               y*(3.26026661647090822d7+y*(2.23355543278099360d9+y*(7.87465017341829930d10 &
               +y*(1.39866710696414565d12+y*(1.17164723371736605d13+y*(4.01839087307656620d13+y*(3.99653257887490811d13))))))))))

         Ci = real(f*sin(x)-g*cos(x))

      ELSE

         STOP 'CI: Something went very wrong'

      END IF

   END FUNCTION Ci

   REAL FUNCTION Bessel(n, x)

      ! Returns the Bessel function of order 'n'
      ! Wraps the Fortran intrinsic functions
      INTEGER, INTENT(IN) :: n
      REAL, INTENT(IN) :: x  
      REAL, PARAMETER :: xlarge = 1e15 ! Set to zero for large values

      IF (x > xlarge) THEN

         ! To stop it going mental for very large values of x
         Bessel = 0.

      ELSE

         IF (n < 0) THEN
            WRITE(*,*) 'BESSEL: Order:', n
            STOP 'BESSEL: cannot call for negative n'
         END IF

         IF (n == 0) THEN
            Bessel = Bessel_J0(x)
         ELSE IF (n == 1) THEN
            Bessel = Bessel_J1(x)
         ELSE
            Bessel = Bessel_JN(n, x)
         END IF

      END IF

   END FUNCTION Bessel

   REAL FUNCTION Gaussian(x, mu, sigma)

      ! Returns the integral-normalised Gaussian
      REAL, INTENT(IN) :: x     ! [-inf:inf]
      REAL, INTENT(IN) :: mu    ! Mean value
      REAL, INTENT(IN) :: sigma ! Root-variance
      REAL :: f1, f2

      f1 = exp(-((x-mu)**2)/(2.*sigma**2))
      f2 = sigma*sqrt(twopi)

      Gaussian = f1/f2

   END FUNCTION Gaussian

   REAL FUNCTION lognormal(x, mean_x, sigma_lnx)

      ! Returns integral-normalised lognormal distribution
      REAL, INTENT(IN) :: x         ! x [0,inf]
      REAL, INTENT(IN) :: mean_x    ! Mean value of x
      REAL, INTENT(IN) :: sigma_lnx ! Sigma for the value of ln(x) !IMPORTANT!
      REAL :: mu, sigma

      IF (mean_x <= 0.) STOP 'LOGNORMAL: Error, mean_x cannot be less than or equal to zero'
      IF (sigma_lnx < 0.) STOP 'LOGNORMAL: Error, sigma_lnx cannot be less than zero'

      sigma = sigma_lnx
      mu = log(mean_x)-0.5*sigma**2

      lognormal = Gaussian(log(x), mu, sigma)/x

   END FUNCTION lognormal

   REAL FUNCTION uniform(x, x1, x2)

      ! Returns integral-normalised one-dimensional top-hat function between x1 and x2
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: x1 ! Lower limit
      REAL, INTENT(IN) :: x2 ! Upper limit

      IF (x < x1 .OR. x > x2) THEN
         uniform = 0.
      ELSE
         uniform = 1./(x2-x1)
      END IF

   END FUNCTION uniform

   REAL FUNCTION Rayleigh(x, sigma)

      ! Returns integral-normalised Rayleigh distribution
      REAL, INTENT(IN) :: x     ! [0:inf]
      REAL, INTENT(IN) :: sigma ! Sigma parameter (*not* root-variance for this distribution)

      IF (sigma <= 0.) STOP 'RAYLEIGH: Error, sigma cannot be less than or equal to zero'

      IF (x < 0.) THEN
         STOP 'RAYLEIGH: Error, x cannot be less than zero'
      ELSE
         Rayleigh = x*exp(-(x**2)/(2.*(sigma**2)))/(sigma**2)
      END IF

   END FUNCTION Rayleigh

   REAL FUNCTION Poisson(n, nbar)

      ! Normalised discrete Poisson probability distribution
      INTEGER, INTENT(IN) :: n ! Number of events to evaluate P_n at, n>=0
      REAL, INTENT(IN) :: nbar ! Mean number of events >0

      Poisson = exp(-nbar)*(nbar**n)/int(factorial(n))

   END FUNCTION Poisson

   REAL FUNCTION exponential(x, mean)

      ! Returns integral-normalised exponential distribution
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: mean

      exponential = exp(-x/mean)/mean

   END FUNCTION exponential

   REAL FUNCTION Lorentzian(x)

      ! Returns integral-normalised Lorentzian distribution
      REAL, INTENT(IN) :: x

      Lorentzian = 2./(pi*(1.+x**2))

   END FUNCTION Lorentzian

   REAL FUNCTION polynomial(x, n)

      ! Returns integral-normalised polynomial distribution
      REAL, INTENT(IN) :: x ! x[0->1]
      REAL, INTENT(IN) :: n ! Polynomail order [n>-1]

      IF (n < -1) STOP 'POLYNOMIAL: Error, index is less than -1'

      IF (x < 0. .OR. x > 1.) THEN
         STOP 'POLYNOMIAL: Error, x is outside range 0 to 1'
      ELSE
         polynomial = (n+1.)*x**n
      END IF

   END FUNCTION polynomial

   REAL FUNCTION Rosenbrock(x, y)

      ! https://en.wikipedia.org/wiki/Rosenbrock_function
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: y

      Rosenbrock = (1.-x)**2+100.*(y-x**2)**2

   END FUNCTION Rosenbrock

   REAL FUNCTION Himmelblau(x, y)
   
      ! https://en.wikipedia.org/wiki/Himmelblau%27s_function
      REAL, INTENT(IN) :: x
      REAL, INTENT(IN) :: y

      Himmelblau = (x**2+y-11.)**2+(x+y**2-7.)**2

   END FUNCTION Himmelblau

END MODULE special_functions
