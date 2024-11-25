import { useState } from 'react';
import Breadcrumb from '../components/Breadcrumbs/Breadcrumb';
import TableOne from '../components/Tables/TableOne';
import TableThree from '../components/Tables/TableThree';
import TableTwo from '../components/Tables/TableTwo';

const Tables = () => {

  const [role, setRole] = useState<String>("Partenaire")

  return (
    <>
      {
        role == "Partenaire" ?
          <div>
            <Breadcrumb pageName="Tables" />

            <div className="flex flex-col gap-10">
              {/* <TableOne /> */}
              <TableTwo />
              {/* <TableThree /> */}
            </div>
          </div>





          : 
          <div>
            <Breadcrumb pageName="Tables" />

            <div className="flex flex-col gap-10">
              <TableOne />
              <TableTwo />
              <TableThree />
            </div>
          </div>
      }

    </>
  );
};

export default Tables;
