import React from 'react';
import productData from './products.json'; // Import the JSON data

function  ListProducts() {
  return (
    <>
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="py-6 px-4 md:px-6 xl:px-7.5">
        <h4 className="text-xl font-semibold text-black dark:text-white">
          Add Product
        </h4>
        </div>
        </div>
    <div className="overflow-x-auto">
      <table className="min-w-full table-auto bg-white shadow-md rounded-lg">
        <thead>
          <tr className="border-b bg-gray-100">
            <th className="py-3 px-4 text-left text-sm font-semibold text-gray-600">Product Name</th>
            <th className="py-3 px-4 text-left text-sm font-semibold text-gray-600">Category</th>
            <th className="py-3 px-4 text-left text-sm font-semibold text-gray-600">Price</th>
            <th className="py-3 px-4 text-left text-sm font-semibold text-gray-600">Quantity</th>
            <th className="py-3 px-4 text-left text-sm font-semibold text-gray-600">Actions</th>
          </tr>
        </thead>
        <tbody>
          {productData.map((product, key) => (
            <tr key={key} className="border-b hover:bg-gray-50">
              <td className="py-3 px-4 text-sm text-gray-800">
                <div className="flex items-center">
                  <div className="h-12 w-16 rounded-md overflow-hidden mr-4">
                    <img
                      src={product.imagePath || '/fallback-image.jpg'} // Fallback image if no image path
                      alt={product.productName}
                      className="object-cover w-full h-full"
                    />
                  </div>
                  <span>{product.productName}</span>
                </div>
              </td>
              <td className="py-3 px-4 text-sm text-gray-800">{product.category}</td>
              <td className="py-3 px-4 text-sm text-gray-800">${product.price}</td>
              <td className="py-3 px-4 text-sm text-gray-800">{product.quantity}</td>
              <td className="py-3 px-4 text-sm text-gray-800">
                <div className="flex space-x-2">
                  <button
                    type="button"
                    className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2.5 dark:bg-blue-600 dark:hover:bg-blue-700"
                  >
                    Viwe
                  </button>
                  <button
                    type="button"
                    className="text-white bg-green-600 hover:bg-green-800 focus:ring-4 focus:ring-green-300 font-medium rounded-lg text-sm px-4 py-2.5 dark:bg-green-600 dark:hover:bg-green-700"
                  >
                    Update
                  </button>
                  <button
                    type="button"
                    className="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2.5 dark:bg-red-600 dark:hover:bg-red-700"
                  >
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
    </>
  );
}

export default ListProducts;
