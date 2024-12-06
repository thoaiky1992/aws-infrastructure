import { clsxMerge } from "@/utils";
import { RenderCondition } from "../common/render-condition";

type THeaders = { title: string; className?: string };

export const THead = () => {
  const headers: THeaders[] = [
    { title: "Username", },
    { title: "Role" },
    { title: "Email" },
    { title: "Description", className: 'w-[180px]' },
    { title: "Country" },
    { title: "Status" },
    { title: "Actiions" , className: 'w-[200px]' },
  ];
  return (
    <thead className="sticky top-0 text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400 shadow">
      <tr>
        <th scope="col" className="p-4 text-center">
          <div className="flex items-center">
            <input
              id="checkbox-all"
              type="checkbox"
              className="w-4 h-4 text-primary-600 bg-gray-100 rounded border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
            />
            <label htmlFor="checkbox-all" className="sr-only">
              checkbox
            </label>
          </div>
        </th>
        <RenderCondition condition={headers.length > 0}>
          {headers.map((header, index) => (
            <th
              key={header.title}
              scope="col"
              className={`text-center ${header.className}`}
            >
              <div
                className={clsxMerge(
                  "my-3 py-1 border-r-[1px] border-slate-400",
                  {
                    "border-none": headers.length - 1 === index,
                    "border-l-[1px]": index === 0,
                  }
                )}
              >
                {header.title}{" "}
              </div>
            </th>
          ))}
        </RenderCondition>
      </tr>
    </thead>
  );
};
