================================================================================
                                L0 units v1.01
================================================================================

Description:
-----------

The package consists of a collection of units, each covering functions for a
fundemental data type (Strings, Numbers, Date/Times and Streams).

  i) cStrings

     A collection of string functions, including:
         * CopyRange, CopyFrom, CopyLeft, CopyRight
         * Paste
         * TrimLeft, TrimRight, Trim, TrimQuotes, TrimEllipse
         * Dup
         * Reverse, IsPalindrome
         * Match
         * PosNext, PosPrev
         * Boyer-Moore-Horspool PosNext
         * Replace, QuoteText, Remove, RemoveDup
         * Count, CountWords
         * PosN
         * Before, After, Between
         * Split, Join
         * PadLeft, PadRight, Pad
         * IsNumber, IsHexNumber, IsInteger, IsReal, IsScientificReal,
           IsQuotedString
         * Number
         * Pack
         * Translate


  ii) cDateTime

     Date manupilation functions, including:

         * Year, Month, Day, Hour, Minute, Second, Millisecond
         * IsEqual, IsAM, IsPM, IsMidnight, IsNoon, IsWeekend
         * Noon, Midnight, FirstDayOfMonth, LastDayOfMonth, NextWorkDay,
           PreviousWorkday, FirstDayOfYear, LastDayOfYear
         * EasterSunday, GoodFriday
         * AddMilliseconds, AddSeconds, AddMinutes, AddHours, AddDays,
           AddWeeks, AddMonths, AddYears
         * DayOfYear, DaysInMonth, DaysInYear, WeekNumber
         * DiffMilliseconds, DiffSeconds, DiffMinutes, DiffHours, DiffDays,
           DiffWeeks, DiffMonths, DiffYears
         * DateTimeToANSI, ANSIToDateTime, DateTimeToISOInteger, DateTimeToISO,
           ISOIntegerToDateTime, TimeToRFCTime, DateTimeToRFC850,
           DateTimeToRFC1123.


  iii) cMaths

     Mathematical functions, including:

         * Mathematical constants
         * RealArray / IntegerArray manipulation
         * Trigonometric functions
         * Primes
         * Rational numbers
         * Complex numbers
         * Vectors
         * Matrices
         * 3D transformations (rotations, scaling, projection)
         * Combinatoric functions
         * Statistical functions (incl probability density functions)
         * Computer maths
         * Hashing functions (XOR, CRC, MD5)
         * Actuarial functions (TVM, Mortality)
         * Numerical solvers (Secant, Newton, Derivates, Simpson Integration)
         * Sets

  iv) cStream

     Stream abstraction and implementation for files and memory. The following
     is implemented for streams:

         * Binary packing/unpacking of simple data types
         * Text parsing


History:
-------

   Release date  Version      cMaths  cStrings  cDateTime   cStream
   ------------  -------      -----   --------  ---------   -------
    26/11/1999     1.00        0.21     0.09       0.02      0.10
    01/12/1999     1.01        0.22     0.10

   See source files for specifics.



Copyright information:
---------------------

These units are copyrighted by David Butler (c) 1995-1999.

Included is the complete source code, so you can use it wherever you want to.
In that same spirit I ask that you to contribute to its further development.
You are not allowed to distribute a modified version of the source files though.
Please send any changes, suggestions or bug reports to the author for inclusion
in the next release.

Contacting the author:
--------------------

e-mail:  david@e.co.za

