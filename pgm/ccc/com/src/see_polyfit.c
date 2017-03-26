/*
 INPUTS:  dependentValues[0..(countOfElements-1)]
          independentValues[0...(countOfElements-1)]
          countOfElements
          order - Order of the polynomial fitting

          dependentValues   :       x_data[] ;
          independentValues :       y_data[] ;
          countOfElements   :       x_data[],y_data[] count,  ==>  countOfElements = 5, x_data[5],y_data[5]
          order             :       <5 !!
      
 OUTPUTS: coefficients[0..order] - indexed by term
               (the (coef*x^3) is coefficients[3])

 RTURN  :
          slope of x_data[(countOfElements-1)]

 EXAMPLE:
          [input:]
          countOfElements=6;
          order=3
          x_data[0], x_data[1], x_data[2], x_data[3], x_data[4], x_data[5]
          y_data[0], y_data[1], y_data[2], y_data[3], y_data[4], y_data[5]
  
          [output:] co ==> coefficients
          co[3] x^3 + co[2] x^2 + co[1] x^1 + co[0]

*/

static double see_pow(double y, int n)  
{  
    double product = 1;
    int i ;
    for (i = 0; i < n; i++)
        product *= y ;
    return product ;
}  

int polyfit(const double*       dependentValues,
            const double*       independentValues,
            unsigned int        countOfElements,
            unsigned int        order,
            double*             slope,
            double*             coefficients)
{
    // Declarations...
    // ----------------------------------
    enum {maxOrder = 5};
    
    double B[maxOrder+1] = {0.0f};
    double P[((maxOrder+1) * 2)+1] = {0.0f};
    double A[(maxOrder + 1)*2*(maxOrder + 1)] = {0.0f};

    double x, y, powx;

    unsigned int ii, jj, kk;

    // Verify initial conditions....
    // ----------------------------------

    // This method requires that the countOfElements > 
    // (order+1) 
    if (countOfElements <= order)
        return -1;

    // This method has imposed an arbitrary bound of
    // order <= maxOrder.  Increase maxOrder if necessary.
    if (order > maxOrder)
        return -1;

    // Begin Code...
    // ----------------------------------

    // Identify the column vector
    for (ii = 0; ii < countOfElements; ii++)
    {
        x    = dependentValues[ii];
        y    = independentValues[ii];
        powx = 1;

        for (jj = 0; jj < (order + 1); jj++)
        {
            B[jj] = B[jj] + (y * powx);
            powx  = powx * x;
        }
    }

    // Initialize the PowX array
    P[0] = countOfElements;

    // Compute the sum of the Powers of X
    for (ii = 0; ii < countOfElements; ii++)
    {
        x    = dependentValues[ii];
        powx = dependentValues[ii];

        for (jj = 1; jj < ((2 * (order + 1)) + 1); jj++)
        {
            P[jj] = P[jj] + powx;
            powx  = powx * x;
        }
    }

    // Initialize the reduction matrix
    //
    for (ii = 0; ii < (order + 1); ii++)
    {
        for (jj = 0; jj < (order + 1); jj++)
        {
            A[(ii * (2 * (order + 1))) + jj] = P[ii+jj];
        }

        A[(ii*(2 * (order + 1))) + (ii + (order + 1))] = 1;
    }

    // Move the Identity matrix portion of the redux matrix
    // to the left side (find the inverse of the left side
    // of the redux matrix
    for (ii = 0; ii < (order + 1); ii++)
    {
        x = A[(ii * (2 * (order + 1))) + ii];
        if (x != 0)
        {
            for (kk = 0; kk < (2 * (order + 1)); kk++)
            {
                A[(ii * (2 * (order + 1))) + kk] = 
                    A[(ii * (2 * (order + 1))) + kk] / x;
            }

            for (jj = 0; jj < (order + 1); jj++)
            {
                if ((jj - ii) != 0)
                {
                    y = A[(jj * (2 * (order + 1))) + ii];
                    for (kk = 0; kk < (2 * (order + 1)); kk++)
                    {
                        A[(jj * (2 * (order + 1))) + kk] = 
                            A[(jj * (2 * (order + 1))) + kk] -
                            y * A[(ii * (2 * (order + 1))) + kk];
                    }
                }
            }
        }
        else
        {
            // Cannot work with singular matrices
            return -1;
        }
    }

    // Calculate and Identify the coefficients
    
/*
    for (ii = 0; ii < (order + 1); ii++)
    {
        for (jj = 0; jj < (order + 1); jj++)
        {
            x = 0;
            for (kk = 0; kk < (order + 1); kk++)
            {
                x = x + (A[(ii * (2 * (order + 1))) + (kk + (order + 1))] *
                    B[kk]);
            }
            coefficients[ii] = x;
           // coefficients[order-ii] = x;
        }
    }
*/

    for (ii = 0; ii < (order + 1); ii++)
    {
        x = 0;
        for (kk = 0; kk < (order + 1); kk++)
        {
            x = x + (A[(ii * (2 * (order + 1))) + (kk + (order + 1))] *
                B[kk]);
        }
        coefficients[ii] = x;
        // coefficients[order-ii] = x;
    }

    *slope =0 ;
    for (ii = 1; ii <= order; ii++)
    {
        *slope = *slope + coefficients[ii] * ii * see_pow( dependentValues[countOfElements-1],(ii-1) ) ; 
    }

    return 0;
}

/*
   co[3] x^3 + co[2] x^2 + co[1] x^1 + co[0]
*/

