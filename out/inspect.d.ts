
export interface InspectOptions {
	depth?: number;
}

/**
 * Inspects the given value and returns a string representation of it.
 * @param value - The value to inspect.
 * @param options - The options for the inspection.
 * @returns The string representation of the value.
 */
export default function inspect(value: unknown, options?: InspectOptions): string;