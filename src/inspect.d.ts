
export interface InspectOptions {
	depth?: number;
}

export default function inspect(value: unknown, options?: InspectOptions): string;