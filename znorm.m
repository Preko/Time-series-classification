function ZNormed = znorm(x)

% Saving and removing first column
x_class=x(:,1);
x_data=x;
x_data(:,1)=[];

% Transpose and length
x_data=x_data';
len=length(x_data(:,1));

% Taking znorm, retransposing, adding class
ZNormed=[x_class ((x_data - kron(mean(x_data),ones(len,1))) ./ kron(std(x_data),ones(len,1)))'];
