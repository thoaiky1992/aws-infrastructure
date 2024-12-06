"use client";

import { useRouter, useSearchParams } from "next/navigation";
import {
  KeyboardEvent,
  Dispatch,
  SetStateAction,
  useState,
  useEffect,
} from "react";
import { Suspense } from "react";
type THeader = { setIsOpen: Dispatch<SetStateAction<boolean>> };
export const Header = ({ setIsOpen }: THeader) => {
  const searchParams = useSearchParams();
  const router = useRouter();
  const [keySearch, setKeySearch] = useState<string>("");

  const handleSearch = () => {
    const params = new URLSearchParams(searchParams.toString());
    params.set("s", keySearch);
    router.replace(`?${params.toString()}`);
  };
  const onKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === "Enter") {
      handleSearch();
    }
  };

  useEffect(() => {
    const s = searchParams.get("s");
    console.log(s);
    if (s) setKeySearch(s);
  }, []);

  return (
    <div className="flex flex-col md:flex-row items-stretch md:items-center md:space-x-3 space-y-3 md:space-y-0 justify-between py-4 border-t dark:border-gray-700">
      <div className="w-[400px]">
        <div className="flex items-center">
          <label htmlFor="simple-search" className="sr-only">
            Search
          </label>
          <div className="relative w-full">
            <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
              <svg
                aria-hidden="true"
                className="w-5 h-5 text-gray-500 dark:text-gray-400"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
                />
              </svg>
            </div>
            <input
              type="text"
              onChange={(e) => setKeySearch(e.target.value)}
              onKeyDown={onKeyDown}
              value={keySearch}
              placeholder="Search for users"
              className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
            />
          </div>
        </div>
      </div>
      <div className="w-full md:w-auto flex flex-col md:flex-row space-y-2 md:space-y-0 items-stretch md:items-center justify-end md:space-x-3 flex-shrink-0 pr-1">
        <button
          type="button"
          onClick={() => setIsOpen(true)}
          className="flex items-center justify-center text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800"
        >
          <svg
            className="h-3.5 w-3.5 mr-1.5 -ml-1"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
            aria-hidden="true"
          >
            <path
              clipRule="evenodd"
              fillRule="evenodd"
              d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z"
            />
          </svg>
          Add User
        </button>
      </div>
    </div>
  );
};
