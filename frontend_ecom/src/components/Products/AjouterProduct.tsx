import React, { useState } from 'react';
import { ClasseProducts } from './ClasseProducts';






const AjouterProduct = () => {

 



  const [selectedOption, setSelectedOption] = useState<string>('');
  const [isOptionSelected, setIsOptionSelected] = useState<boolean>(false);
  const [productName, setProductName] = useState<string>('');
  const [price, setPrice] = useState<string>('');
  const [quantity, setQuantity] = useState<string>('');
  const [description, setDescription] = useState<string>('');
  const [picture, setPicture] = useState<File | null>(null);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [showError, setShowError] = useState<boolean>(false);
  const [showSuccess, setShowSuccess] = useState<boolean>(false);



 

  

  const changeTextColor = () => {
    setIsOptionSelected(true);
  };
  const handleValidation = () => {
    let formErrors: { [key: string]: string } = {};
    if (!productName) formErrors.productName = "Product name is required.";
    if (!price || isNaN(Number(price)) || Number(price) <= 0) formErrors.price = "Enter a valid price.";
    if (!quantity || isNaN(Number(quantity)) || Number(quantity) <= 0) formErrors.quantity = "Enter a valid quantity.";
    if (!selectedOption) formErrors.category = "Please select a category.";
    if (!description) formErrors.description = "Description is required.";
    if (!picture) formErrors.picture = "Please upload a product picture.";

    setErrors(formErrors);
    return Object.keys(formErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (handleValidation()) {
      setShowError(false);
      setShowSuccess(true);


      const newProduct: ClasseProducts = {
        image: picture,
        productName,
        category: selectedOption,
        price: Number(price),
        quantity: Number(quantity),
        description,
      }

      const idUser=localStorage.getItem("userId")


      const formData = new FormData();
      formData.append('image', picture as Blob);
      formData.append('name', productName);
      formData.append('category', selectedOption);
      formData.append('price', price);
      formData.append('quantity', quantity);
      formData.append('description', description);
      formData.append('idUser', idUser);
     
     


      console.log("Product added successfully:", formData);
      try {
        const response = await fetch('https://localhost:7223/api/product', {
          method: 'POST',
          body: formData,
          headers: {
            'Content-Type': 'multipart/form-data',
            },
            });
            const data = await response.json();
            console.log(data);
          }
          catch (error) {
            console.error(error);
            }
            
           

      setProductName('');
      setPrice('');
      setQuantity('');
      setSelectedOption('');
      setDescription('');
      setPicture(null);
      setIsOptionSelected(false);


    }
    else {
      setShowError(true);
      setShowSuccess(false);
    }
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="py-6 px-4 md:px-6 xl:px-7.5">
        <h4 className="text-xl font-semibold text-black dark:text-white">
          Add Product
        </h4>
        {/* Success Alert */}
        {showSuccess && (
          <div className="flex w-full border-l-6 border-[#34D399] bg-[#34D399] bg-opacity-[15%] px-7 py-8 shadow-md dark:bg-[#1B1B24] dark:bg-opacity-30 md:p-9">
            <div className="mr-5 flex h-9 w-full max-w-[36px] items-center justify-center rounded-lg bg-[#34D399]">
              <svg width="16" height="12" viewBox="0 0 16 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                  d="M15.2984 0.826822L15.2868 0.811827L15.2741 0.797751C14.9173 0.401867 14.3238 0.400754 13.9657 0.794406L5.91888 9.45376L2.05667 5.2868C1.69856 4.89287 1.10487 4.89389 0.747996 5.28987C0.417335 5.65675 0.417335 6.22337 0.747996 6.59026L0.747959 6.59029L0.752701 6.59541L4.86742 11.0348C5.14445 11.3405 5.52858 11.5 5.89581 11.5C6.29242 11.5 6.65178 11.3355 6.92401 11.035L15.2162 2.11161C15.5833 1.74452 15.576 1.18615 15.2984 0.826822Z"
                  fill="white"
                  stroke="white"
                ></path>
              </svg>
            </div>
            <div className="w-full">
              <h5 className="mb-3 text-lg font-semibold text-black dark:text-[#34D399] ">
                Product Added Successfully
              </h5>
              <p className="text-base leading-relaxed text-body">
                The product has been added to the list successfully.
              </p>
            </div>
          </div>
        )}
        {showError && (
          <div className="flex w-full border-l-6 border-[#F87171] bg-[#F87171] bg-opacity-[15%] px-7 py-8 shadow-md dark:bg-[#1B1B24] dark:bg-opacity-30 md:p-9">
            <div className="mr-5 flex h-9 w-full max-w-[36px] items-center justify-center rounded-lg bg-[#F87171]">
              <svg width="13" height="13" viewBox="0 0 13 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                  d="M6.4917 7.65579L11.106 12.2645C11.2545 12.4128 11.4715 12.5 11.6738 12.5C11.8762 12.5 12.0931 12.4128 12.2416 12.2645C12.5621 11.9445 12.5623 11.4317 12.2423 11.1114C12.2422 11.1113 12.2422 11.1113 12.2422 11.1113C12.242 11.1111 12.2418 11.1109 12.2416 11.1107L7.64539 6.50351L12.2589 1.91221L12.2595 1.91158C12.5802 1.59132 12.5802 1.07805 12.2595 0.757793C11.9393 0.437994 11.4268 0.437869 11.1064 0.757418C11.1063 0.757543 11.1062 0.757668 11.106 0.757793L6.49234 5.34931L1.89459 0.740581L1.89396 0.739942C1.57364 0.420019 1.0608 0.420019 0.740487 0.739944C0.42005 1.05999 0.419837 1.57279 0.73985 1.89309L6.4917 7.65579ZM6.4917 7.65579L1.89459 12.2639L1.89395 12.2645C1.74546 12.4128 1.52854 12.5 1.32616 12.5C1.12377 12.5 0.906853 12.4128 0.758361 12.2645L1.1117 11.9108L0.758358 12.2645C0.437984 11.9445 0.437708 11.4319 0.757539 11.1116C0.757812 11.1113 0.758086 11.111 0.75836 11.1107L5.33864 6.50287L0.740487 1.89373L6.4917 7.65579Z"
                  fill="#ffffff"
                  stroke="#ffffff"
                ></path>
              </svg>
            </div>
            <div className="w-full">
              <h5 className="mb-3 font-semibold text-[#B45454]">There were errors with your submission</h5>

            </div>
          </div>
        )}
        <form onSubmit={handleSubmit} className="flex flex-col gap-5.5 p-6.5">

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="mb-3 block text-black dark:text-white">
                Product Name
              </label>
              <input
                type="text"
                placeholder="Enter product name"
                value={productName}
                onChange={(e) => setProductName(e.target.value)}
                className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
              />
              {errors.productName && <p className="text-red-500">{errors.productName}</p>}
            </div>

            <div>
              <label className="mb-3 block text-black dark:text-white">
                Price
              </label>
              <input
                type="number"
                placeholder="Enter product price"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
              />
              {errors.price && <p className="text-red-500">{errors.price}</p>}
            </div>

            <div>
              <label className="mb-3 block text-black dark:text-white">
                Quantity
              </label>
              <input
                type="number"
                placeholder="Enter quantity"
                value={quantity}
                onChange={(e) => setQuantity(e.target.value)}
                className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
              />
              {errors.quantity && <p className="text-red-500">{errors.quantity}</p>}
            </div>

            <div>
              <label className="mb-3 block text-black dark:text-white">
                Category
              </label>
              <select
                value={selectedOption}
                onChange={(e) => {
                  setSelectedOption(e.target.value);
                  changeTextColor();
                }}
                className={`relative z-20 w-full appearance-none rounded border border-stroke bg-transparent py-3 px-12 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input ${isOptionSelected ? 'text-black dark:text-white' : ''}`}
              >
                <option value="" disabled className="text-body dark:text-bodydark">
                  Select Category
                </option>
                <option value="USA">USA</option>
                <option value="UK">UK</option>
                <option value="Canada">Canada</option>
              </select>
              {errors.category && <p className="text-red-500">{errors.category}</p>}
            </div>

            <div>
              <label className="mb-3 block text-black dark:text-white">
                Description
              </label>
              <textarea
                rows={6}
                placeholder="Enter description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
              ></textarea>
              {errors.description && <p className="text-red-500">{errors.description}</p>}
            </div>

            <div>
              <label className="mb-3 block text-black dark:text-white">
                Picture Products
              </label>
              <input
                type="file"
                onChange={(e) => setPicture(e.target.files ? e.target.files[0] : null)}
                className="w-full cursor-pointer rounded-lg border-[1.5px] border-stroke bg-transparent outline-none transition file:mr-5 file:border-collapse file:cursor-pointer file:border-0 file:border-r file:border-solid file:border-stroke file:bg-whiter file:py-3 file:px-5 file:hover:bg-primary file:hover:bg-opacity-10 focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:file:border-form-strokedark dark:file:bg-white/30 dark:file:text-white dark:focus:border-primary"
              />
              {errors.picture && <p className="text-red-500">{errors.picture}</p>}
            </div>
          </div>

          <input type="submit" value="Add Product"
            className="inline-flex items-center justify-center gap-2.5 rounded-md bg-primary py-4 px-10 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10"
          />
        </form>
      </div>
    </div>
  );
};

export default AjouterProduct;
