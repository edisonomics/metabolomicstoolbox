function spectra=pipe2matlab(filepath)
% spectra=pipe2matlab(name)
%
% Greg Stupp UF
% Reads in an nmrPipe ft file. Outputs
% spectra.real,spectra.ppm1,spectra.ppm2,spectra.Title
% Uses functions borrowed from:
%
% Covariance NMR Toolbox, ver. 1.0b, (C) (2010) David A. Snyder(1) along with Timothy Short(1),
%     Leigh Alzapiedi(1) and Rafael Br�schweiler (2)
%     (1) Department of Chemistry, College of Science and Health, William Paterson University
%     (2) Department of Chemistry and NHMFL, Florida State University
%
% License
%
% Copyright (c) 2010, David Snyder
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
% * Redistributions of source code must retain the above copyright notice, this
%  list of conditions and the following disclaimer.
%
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% Currently, Cite As
% David Snyder (2022). Covariance NMR Toolbox
% (https://www.mathworks.com/matlabcentral/fileexchange/27264-covariance-nmr-toolbox)
% MATLAB Central File Exchange. Retrieved February 11, 2022.




%
% Arguments:
% name                 name of file (including extension)

[pathstr, title, ext] = fileparts(filepath);
[spectra.real axes]=read_nmrp(filepath);

ppm=inc2ppm(axes);
if length(fieldnames(ppm))==1
    spectra.ppm=ppm.ppm1;
else
    spectra.ppm1=ppm.ppm1;
    spectra.ppm2=ppm.ppm2;
end
spectra.real=spectra.real';
spectra.Title=title;
end
