"""
ADD COMMENTS TO THIS FILE 
"""

#The print_combination function creates a local array of length r, with 0 as each element in the array.
#The function then calls combination_aux
def print_combination(arr, n, r):

    data = [0] * r
 
    combination_aux(arr, n, r, 0, data, 0)
 
def combination_aux(arr, n, r, index, data, i):     #Define the function combination_aux with parameters arr, n, r, index, data and i

    if (index == r):                                #Run the following lines if the value of index is equal to r
        for j in range(r):                          #Loop from 0 to value r
            print(data[j], end = " ")               #Print element number j in the data array
        print()                                     #Print nothing
        return                                      #Return nothing, exit the function
 
    if (i >= n):                                    #Run the fiollowing lines if the value of i is greater than or equal to n
        return                                      #Return nothing, exit the function
 
    data[index] = arr[i]                            #Set element number "index" in the "data" array to element number "i" in the "arr" array
    combination_aux(arr, n, r, index + 1,           #The function calls itself in a recursice manner, with the values of index and i incremented by 1
                    data, i + 1)
 
    combination_aux(arr, n, r, index,               #The function calls itself in a recursice manner, with the value of i incremented by 1
                    data, i + 1)
 
#This main function defines local variables arr, r and n, 
#before calling the function print_combination with those values as the parameters
def main():
    arr = [1, 2, 3, 4, 5]
    r = 3
    n = len(arr)
    print_combination(arr, n, r)

main() #Call the main function