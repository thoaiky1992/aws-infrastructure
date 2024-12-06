import axiosInstance from "@/utils/axios";
import { AxiosRequestConfig } from "axios";

export type HttpResponseMeta = {
  currentPage: number;
  totalPage: number;
  offset: number;
  limit: number;
  count: number;
};

export type HttpResponseData<T> = {
  data: T;
  statusCode: number;
  message?: string;
};
export type HttpResponseMultiData<T> = {
  data: T[];
  statusCode: number;
  message?: string;
  meta?: HttpResponseMeta;
};

interface ICrudService<T> {
  getAll: () => Promise<HttpResponseMultiData<T>>;
  getOne: (id: string) => Promise<HttpResponseData<T>>;
  createOne: (data: Partial<T>) => Promise<HttpResponseData<T>>;
  updateOne: (id: string, data: Partial<T>) => Promise<HttpResponseData<T>>;
  deleteOne: (id: string) => Promise<HttpResponseData<T>>;
}
export class CrudService<T> implements ICrudService<T> {
  public axios = axiosInstance; //
  public table: string; // product
  public axiosRequestConfig: AxiosRequestConfig = {};
  constructor(table: string) {
    this.table = table;
  }
  async getAll(): Promise<HttpResponseMultiData<T>> {
    try {
      const response = await axiosInstance.get(`/${this.table}`, {
        ...this.axiosRequestConfig,
      });
      return { ...response.data };
    } finally {
      this.axiosRequestConfig = {};
    }
  }
  async getOne(id: string): Promise<HttpResponseData<T>> {
    try {
      const response = await axiosInstance.get(`/${this.table}/${id}`, {
        ...this.axiosRequestConfig,
      });
      return { ...response.data };
    } finally {
      this.axiosRequestConfig = {};
    }
  }
  async createOne(data: Partial<T>): Promise<HttpResponseData<T>> {
    try {
      const response = await axiosInstance.post(`/${this.table}`, data, {
        ...this.axiosRequestConfig,
      });
      return { ...response.data };
    } finally {
      this.axiosRequestConfig = {};
    }
  }
  async updateOne(id: string, data: Partial<T>): Promise<HttpResponseData<T>> {
    try {
      const response = await axiosInstance.put(`/${this.table}/${id}`, data, {
        ...this.axiosRequestConfig,
      });
      return { ...response.data };
    } finally {
      this.axiosRequestConfig = {};
    }
  }
  async deleteOne(id: string): Promise<HttpResponseData<T>> {
    try {
      const response = await axiosInstance.delete(`/${this.table}/${id}`, {
        ...this.axiosRequestConfig,
      });
      return { ...response.data };
    } finally {
      this.axiosRequestConfig = {};
    }
  }
  public options(options: AxiosRequestConfig) {
    this.axiosRequestConfig = { ...this.axiosRequestConfig, ...options };
    return this;
  }
  public params(params: any) {
    this.axiosRequestConfig = {
      ...this.axiosRequestConfig,
      params: { ...this.axiosRequestConfig.params, ...params },
    };
    return this;
  }
}
