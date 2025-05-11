/**
 * The Error object.
 */
export interface Error {
  message: string;
  name: string;
  stack?: string;
}

/**
 * The Error constructor.
 */
interface ErrorConstructor {
  /**
   * Creates a new Error object.
   * @param message - The message of the error.
   * @returns A new Error object.
   */
  new (message?: string): Error;
  (message?: string): Error;
  readonly captureStackTrace: (error: Error, options?: Callback) => void;
}
export const Error: ErrorConstructor;