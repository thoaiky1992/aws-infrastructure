import { HomePage } from "@/components/HomePage";
import { CountryService } from "@/services/contry.service";
import { RoleService } from "@/services/role.service";

export const metadata = {
  title: "My Page",
  description: "This is my page description",
};

export default function Home() {
  return <HomePage />;
}
