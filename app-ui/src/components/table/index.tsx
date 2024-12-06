'use client';

import { RenderCondition } from "../common/render-condition";
import { Header } from "./header";
import { Row } from "./row";
import { THead } from "./thead";
import { ModalForm } from "../modal/modal-form";
import { ModalConfirm } from "../modal/modal-confirm";
import { TUser } from "@/models/user.model";
import { UserService } from "@/services/user.service";
import { useEffect, useState } from "react";
import { NoData } from "./no-data";
import { TRole } from "@/models/role.model";
import { TCountry } from "@/models/country.model";
import { useSearchParams } from "next/navigation";

type TTable = { roles: TRole[]; countries: TCountry[] };

export const Table = ({ roles, countries }: TTable) => {
  const [users, setUsers] = useState<TUser[]>([]);
  const searchParams = useSearchParams();

  const [isOpenModalConfirm, setIsOpenModalConfirm] = useState<boolean>(false);
  const [isOpenModalForm, setIsOpenModalForm] = useState<boolean>(false);
  const [selectedUser, setSelectedUser] = useState<TUser | undefined>();

  const onActions = (user: TUser, action: "edit" | "delete") => {
    setSelectedUser(() => ({ ...user }));
    if (action === "edit") {
      setIsOpenModalForm(true);
    } else {
      setIsOpenModalConfirm(true);
    }
  };

  const fetchUser = async () => {
    const s = searchParams.get("s") || "";
    const res = await UserService.getManyWithConditions({
      where: {
        OR: [{ email: { contains: s } }, { username: { contains: s } }],
      },
      orderBy: {
        createdAt: 'desc'
      },
      include: { role: true, country: true },
    });
    setUsers(res.data);
  };
  useEffect(() => {
    fetchUser();
  }, [searchParams.get("s")]);

  useEffect(() => {
    if (!isOpenModalForm) {
      setSelectedUser(undefined);
    }
  }, [isOpenModalForm]);
  useEffect(() => {
    if (!isOpenModalConfirm) {
      setSelectedUser(undefined);
    }
  }, [isOpenModalConfirm]);
  return (
    <div>
      <Header setIsOpen={setIsOpenModalForm} />
      <div className="overflow-x-auto h-[calc(100vh_-_180px)] overflow-y-auto">
        <table className="w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <THead />
          <tbody>
            <RenderCondition condition={users.length > 0} fallback={<NoData />}>
              {users.map((user) => (
                <Row
                  key={user.id}
                  user={user}
                  onActions={onActions}
                />
              ))}
            </RenderCondition>
          </tbody>
        </table>
        <RenderCondition condition={isOpenModalForm}>
          <ModalForm
            isOpen={isOpenModalForm}
            setIsOpen={setIsOpenModalForm}
            roles={roles}
            countries={countries}
            selectedUser={selectedUser}
            fetchUser={fetchUser}
          />
        </RenderCondition>
        <RenderCondition condition={isOpenModalConfirm}>
          <ModalConfirm
            isOpen={isOpenModalConfirm}
            setIsOpen={setIsOpenModalConfirm}
            selectedUser={selectedUser}
            fetchUser={fetchUser}
          />
        </RenderCondition>
      </div>
    </div>
  );
};
