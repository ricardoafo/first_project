import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Result = { 'ok' : StudentProfile } |
  { 'err' : string };
export type Result_1 = { 'ok' : null } |
  { 'err' : string };
export interface StudentProfile {
  'graduate' : boolean,
  'name' : string,
  'team' : string,
}
export interface _SERVICE {
  'addMyProfile' : ActorMethod<[StudentProfile], Result_1>,
  'seeAProfile' : ActorMethod<[Principal], Result>,
  'updateMyProfile' : ActorMethod<[Principal, StudentProfile], Result>,
}
