"use client";

import { FC, MouseEvent, ReactNode, useEffect, useRef } from "react";
import { RenderCondition } from "../common/render-condition";

type TChildren = { onClose: any };
interface ConfirmDialogProps {
  children: ReactNode | ((props: TChildren) => ReactNode); // Allow children to be either a node or a function
  isCloseOutSide?: boolean;
  handleConfirm?: any;
  isOpen: boolean;
  setIsOpen: any;
  className?: string;
}

const ModalCommon: FC<ConfirmDialogProps> = ({
  children,
  isCloseOutSide,
  isOpen,
  setIsOpen,
  className = "",
}) => {
  const modalRef = useRef<HTMLDivElement | null>(null);
  const animateType = {
    enter: "animate-modal-scale-enter",
    leave: "animate-modal-scale-leave",
  };

  const onClose = () => {
    if (modalRef.current) {
      modalRef.current.classList.remove(animateType.enter);
      modalRef.current.classList.add(animateType.leave);
    }
    setTimeout(() => {
      setIsOpen(() => false);
    }, 300);
  };

  const onCloseOutSide = (e: MouseEvent<HTMLDivElement>) => {
    if (
      modalRef.current &&
      !modalRef.current.contains(e.target as any) &&
      isCloseOutSide
    ) {
      onClose();
    }
  };

  useEffect(() => {
    if (isOpen && modalRef.current) {
      modalRef.current.classList.add(animateType.enter);
      modalRef.current.classList.remove(animateType.leave);
    }
  }, [isOpen]);

  return (
    <RenderCondition condition={isOpen}>
      <div
        className="modal-wrap fixed left-0 top-0 z-[9999999999999999] h-screen w-screen bg-transparent"
        onClick={onCloseOutSide}
      >
        <div className="relative flex h-full w-full justify-center">
          <div className="absolute left-0 top-0 z-10 h-full w-full bg-slate-300 opacity-80"></div>
          <div className="absolute top-[50%] z-20  !translate-y-[-50%]">
            <div
              ref={modalRef}
              className={`${animateType.enter} modal-content rounded-xl bg-slate-100 shadow-xl drop-shadow-lg ${className}`}
            >
              {typeof children === "function"
                ? children({ onClose })
                : children}
            </div>
          </div>
        </div>
      </div>
    </RenderCondition>
  );
};

export default ModalCommon;
