import axios, { AxiosInstance, InternalAxiosRequestConfig } from "axios";

const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL;
const axiosInstance: AxiosInstance = axios.create({
  baseURL: process.env.NODE_ENV === "production" ? "/api" : BACKEND_URL + "/api",
  // baseURL: '/api',
  headers: {
    "content-type": "application/json",
  },
});
axiosInstance.interceptors.request.use(
  async (config: InternalAxiosRequestConfig<any>) => {
    // Do something before request is sent

    return config;
  },
  (error) => {
    Promise.reject(error);
  }
);
axiosInstance.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default axiosInstance;
