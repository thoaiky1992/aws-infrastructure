import { ReactNode } from "react";

type RenderConditionProps = {
  children: ReactNode;
  condition: boolean;
  fallback?: ReactNode;
};

export const RenderCondition = ({
  children,
  condition,
  fallback,
}: RenderConditionProps) => {
  return condition ? children : fallback ?? null;
};
