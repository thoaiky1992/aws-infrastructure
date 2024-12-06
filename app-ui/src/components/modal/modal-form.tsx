"use client";
import { TCountry } from "@/models/country.model";
import { TRole } from "@/models/role.model";
import { TUser } from "@/models/user.model";
import {
  ChangeEvent,
  Dispatch,
  SetStateAction,
  useEffect,
  useState,
} from "react";
import ModalCommon from "../common/modal-common";
import { RenderCondition } from "../common/render-condition";
import { UserService } from "@/services/user.service";

type TModalForm = {
  isOpen: boolean;
  setIsOpen: Dispatch<SetStateAction<boolean>>;
  roles: TRole[];
  countries: TCountry[];
  selectedUser?: TUser;
  fetchUser: () => void
};

export const ModalForm = ({
  isOpen,
  setIsOpen,
  roles,
  countries,
  selectedUser,
  fetchUser
}: TModalForm) => {
  const [user, setUser] = useState<Partial<TUser>>({
    username: "",
    email: "",
    description: "",
    active: false,
    roleId: roles[0].id,
    countryId: countries[0].id,
  });

  const onChange = (
    e: ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    switch (name) {
      case "active":
        setUser((preUser) => ({
          ...preUser,
          [name]: (e.target as HTMLInputElement).checked,
        }));
        break;
      case "roleId":
      case "countryId":
        setUser((preUser) => ({ ...preUser, [name]: Number(value) }));
        break;
      default:
        setUser((preUser) => ({ ...preUser, [name]: value }));
        break;
    }
  };

  const handleCreateUser = (callback: () => void) => {
    callback();
    if(selectedUser) {
      const { id = 0, role = {}, country = {} , ...rest } = user;
      UserService.updateOne(String(selectedUser.id), rest).finally(() => fetchUser())
    } else {
      const { id = 0, role = {}, country = {} , ...rest } = user;
      UserService.createOne(rest).finally(() => fetchUser())
    }
  };

  useEffect(() => {
    if(selectedUser) {
      setUser({...selectedUser});
    }
  }, [selectedUser]);
  return (
    <ModalCommon isOpen={isOpen} setIsOpen={setIsOpen}>
      {({ onClose }) => (
        <div className="relative bg-white rounded-lg shadow dark:bg-gray-800 min-w-[600px]">
          {/* Modal header */}
          <div className="flex justify-between items-center pb-4 mb-4 rounded-t border-b sm:mb-5 dark:border-gray-600 py-4 px-4">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
              Add User
            </h3>
            <button
              onClick={() => onClose()}
              type="button"
              className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white"
            >
              <svg
                aria-hidden="true"
                className="w-5 h-5"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fillRule="evenodd"
                  d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                  clipRule="evenodd"
                />
              </svg>
              <span className="sr-only">Close modal</span>
            </button>
          </div>
          {/* Modal body */}
          <div className=" px-4 pb-5">
            <div className="grid gap-4 mb-4 sm:grid-cols-2">
              <div>
                <label
                  htmlFor="name"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  User Name
                </label>
                <input
                  onChange={onChange}
                  value={user?.username}
                  name="username"
                  className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                  placeholder="Type username"
                />
              </div>
              <div>
                <label
                  htmlFor="category"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Role
                </label>
                <select
                  onChange={onChange}
                  value={user?.roleId}
                  name="roleId"
                  className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                >
                  <RenderCondition condition={roles.length > 0}>
                    {roles.map((role) => (
                      <option key={role.id} value={role.id}>
                        {role.name}
                      </option>
                    ))}
                  </RenderCondition>
                </select>
              </div>
              <div>
                <label
                  htmlFor="brand"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Email
                </label>
                <input
                  onChange={onChange}
                  value={user?.email}
                  name="email"
                  className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                  placeholder="Type email"
                />
              </div>
              <div>
                <label
                  htmlFor="category"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Country
                </label>
                <select
                  onChange={onChange}
                  value={user?.countryId}
                  name="countryId"
                  className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                >
                  <RenderCondition condition={countries.length > 0}>
                    {countries.map((country) => (
                      <option key={country.id} value={country.id}>
                        {country.name}
                      </option>
                    ))}
                  </RenderCondition>
                </select>
              </div>

              <div className="sm:col-span-2">
                <label
                  htmlFor="description"
                  className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >
                  Description
                </label>
                <textarea
                  onChange={onChange}
                  value={user?.description || ''}
                  name="description"
                  rows={4}
                  className="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                  placeholder="Write user description here"
                />
              </div>
            </div>
            <div className="mb-4 space-y-4 sm:flex sm:space-y-0">
              <div className="flex items-center mr-4">
                <input
                  type="checkbox"
                  onChange={onChange}
                  checked={user?.active}
                  name="active"
                  className="w-4 h-4 bg-gray-100 rounded border-gray-300 text-primary-600 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                />
                <label
                  htmlFor="inline-checkbox"
                  className="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                >
                  Active
                </label>
              </div>
            </div>

            <div className="items-center space-y-4 sm:flex sm:space-y-0 sm:space-x-4 mt-10">
              <button
                onClick={() => handleCreateUser(() => onClose())}
                type="button"
                className="w-full sm:w-auto justify-center text-white inline-flex bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
              >
                { selectedUser? 'Edit': 'Add' } User
              </button>
            </div>
          </div>
        </div>
      )}
    </ModalCommon>
  );
};
