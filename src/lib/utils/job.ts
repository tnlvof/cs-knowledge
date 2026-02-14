import { JOBS, DEFAULT_JOB, JOB_TIER_PREFIX } from "@/constants/jobs";

export function getJobInfo(jobClass: string, jobTier: number) {
  const currentJob = jobClass === "novice"
    ? DEFAULT_JOB
    : JOBS.find((j) => j.id === jobClass) || DEFAULT_JOB;
  const displayName = jobTier > 0
    ? `${JOB_TIER_PREFIX[jobTier] || ""}${currentJob.name}`
    : currentJob.name;
  return { job: currentJob, displayName };
}
