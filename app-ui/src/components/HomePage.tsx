"use client";
import { Table } from "@/components/table";
import { TCountry } from "@/models/country.model";
import { TRole } from "@/models/role.model";
import { CountryService } from "@/services/contry.service";
import { RoleService } from "@/services/role.service";
import Image from "next/image";
import { Suspense, useEffect, useState } from "react";

export const HomePage = () => {
  const [roles, setRoles] = useState<TRole[]>([]);
  const [countries, setCountries] = useState<TCountry[]>([]);

  const fetchData = async () => {
    const [roleRes, CountryRes] = await Promise.all([
      RoleService.getAll(),
      CountryService.getAll(),
    ]);
    setRoles(roleRes.data);
    setCountries(CountryRes.data);
  };

  useEffect(() => {
    fetchData();
  }, []);
  return (
    <>
      <Suspense>
        <section className="bg-white h-screen w-screen dark:bg-gray-900 p-3 sm:p-5 antialiased">
          <div className="mx-auto max-w-screen-xl px-4">
            <div className="bg-white dark:bg-gray-800 relative overflow-hidden">
              <div className="flex justify-between items-center">
                <div className="flex pb-4 gap-2">
                  <Image
                    src={"/product-management-25.png"}
                    width={0}
                    height={0}
                    sizes="100%"
                    className="w-[40px]"
                    alt=""
                  />
                  <h1 className="font-bold text-3xl drop-shadow-2xl mt-[2px] text-primary-600">
                    KySomaio
                  </h1>
                </div>
                <div className="text-primary-600 font-semibold text-lg">version: {process.env.NEXT_PUBLIC_VERSION}</div>
              </div>

              <Table roles={roles} countries={countries} />
            </div>
          </div>
        </section>
      </Suspense>
    </>
  );
};
