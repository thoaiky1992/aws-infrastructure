import { TUser } from "@/models/user.model";
import { clsxMerge } from "@/utils";
type TRow = {
  user: TUser;
  onActions: (user: TUser, type: "edit" | "delete") => void;
};
export const Row = ({ user, onActions }: TRow) => {
  return (
    <tr className="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
      <td className="p-4 w-4">
        <div className="flex items-center justify-center">
          <input
            id="checkbox-table-search-1"
            type="checkbox"
            className="w-4 h-4 text-primary-600 bg-gray-100 rounded border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
          />
          <label htmlFor="checkbox-table-search-1" className="sr-only">
            checkbox
          </label>
        </div>
      </td>
      <th
        scope="row"
        className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white"
      >
        <div className="flex items-center justify-center mr-3">
          {user.username}
        </div>
      </th>
      <td className="px-4 py-3 text-center">
        <span className="bg-primary-100 text-primary-800 text-xs font-medium px-2 py-0.5 rounded dark:bg-primary-900 dark:text-primary-300">
          {user?.role?.name}
        </span>
      </td>
      <td className="px-4 py-3 text-center font-medium text-gray-900 whitespace-nowrap dark:text-white">
        <div className="flex items-center justify-center">{user.email}</div>
      </td>
      <td className="px-4 py-3 text-center font-medium text-gray-900 dark:text-white whitespace-pre-line">
        {user?.description}
      </td>
      <td className="px-4 py-3 text-center font-medium text-gray-900 whitespace-nowrap dark:text-white">
        {user?.country?.name}
      </td>
      <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
        <div className="flex items-center justify-center">
          <div className="w-[80px] flex items-center justify-start gap-2">
            <span className="relative flex h-3 w-3">
              <span
                className={clsxMerge(
                  "animate-ping absolute inline-flex h-full w-full rounded-full bg-red-500 opacity-75",
                  { "bg-green-500": user.active }
                )}
              ></span>
              <span
                className={clsxMerge(
                  "relative inline-flex rounded-full h-3 w-3 bg-red-500",
                  { "bg-green-500": user.active }
                )}
              ></span>
            </span>
            {user.active ? "active" : "inactive"}
          </div>
        </div>
      </td>
      <td className="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white">
        <div className="flex items-center justify-end space-x-4">
          <button
            type="button"
            onClick={() => onActions(user, "edit")}
            className="py-2 px-3 flex items-center text-sm font-medium text-center text-white bg-primary-700 rounded-lg hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-4 w-4 mr-2 -ml-0.5"
              viewBox="0 0 20 20"
              fill="currentColor"
              aria-hidden="true"
            >
              <path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z" />
              <path
                fillRule="evenodd"
                d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z"
                clipRule="evenodd"
              />
            </svg>
            Edit
          </button>
          <button
            type="button"
            onClick={() => onActions(user, "delete")}
            className="flex items-center text-red-700 hover:text-white border border-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-3 py-2 text-center dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-4 w-4 mr-2 -ml-0.5"
              viewBox="0 0 20 20"
              fill="currentColor"
              aria-hidden="true"
            >
              <path
                fillRule="evenodd"
                d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z"
                clipRule="evenodd"
              />
            </svg>
            Delete
          </button>
        </div>
      </td>
    </tr>
  );
};
