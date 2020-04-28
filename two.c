int add(int a, int b)
{
	return a + b;
}
int main() {
	int (*a_fptr)(int, int) = add;

	int (*b_fptr)(int, int) = add;

	int op1 = 1, op2 = 2;

	unsigned result = a_fptr(op1,op2);
	unsigned result2= b_fptr(op1,op2);
	return 0;

}
