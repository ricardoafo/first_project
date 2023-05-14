export const idlFactory = ({ IDL }) => {
  const StudentProfile = IDL.Record({
    'graduate' : IDL.Bool,
    'name' : IDL.Text,
    'team' : IDL.Text,
  });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Result = IDL.Variant({ 'ok' : StudentProfile, 'err' : IDL.Text });
  return IDL.Service({
    'addMyProfile' : IDL.Func([StudentProfile], [Result_1], []),
    'seeAProfile' : IDL.Func([IDL.Principal], [Result], ['query']),
    'updateMyProfile' : IDL.Func([IDL.Principal, StudentProfile], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
