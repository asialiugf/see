#ifndef POLYFIT_H_
#define POLYFIT_H_

#ifdef __cplusplus
extern "C" {
#endif

/*

 METHOD:  polyfit

 INPUTS:  dependentValues[0..(countOfElements-1)]
          independentValues[0...(countOfElements-1)]
          countOfElements
          order - Order of the polynomial fitting

          dependentValues   :       x_data[] ;
          independentValues :       y_data[] ;
          countOfElements   :       x,y data count,  ==>  countOfElements = 5, x_data[5],y_data[5]
          order             :       <5 !!
      
 OUTPUTS: coefficients[0..order] - indexed by term
               (the (coef*x^3) is coefficients[3])

 EXAMPLE:
          [input:]
          countOfElements=6;
          order=3
          x_data[0], x_data[1], x_data[2], x_data[3], x_data[4], x_data[5]
          y_data[0], y_data[1], y_data[2], y_data[3], y_data[4], y_data[5]
  
          [output:] co ==> coefficients
          co[3] x^3 + co[2] x^2 + co[1] x^1 + co[0]

*/
 

int polyfit(const double* const dependentValues,
            const double* const independentValues,
            unsigned int        countOfElements,
            unsigned int        order,
            double*             slope,
            double*             coefficients);


#ifdef __cplusplus
}
#endif

#endif
