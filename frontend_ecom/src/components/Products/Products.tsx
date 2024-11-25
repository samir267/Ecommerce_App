import React from 'react'
import AjouterProduct from './AjouterProduct'
import TableTwo from '../Tables/TableTwo'
import ListProducts from './ListProducts'

function Products() {
  return (
   
    <div>
      <div className="container">
      <AjouterProduct/>
      <br />
      <ListProducts/>

        <br />
        <TableTwo/>

       
        </div>
    </div>
  )
}

export default Products