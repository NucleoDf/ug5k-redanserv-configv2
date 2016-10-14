// PruebaTemplatesReferencias.cpp: define el punto de entrada de la aplicación de consola.
//

#include "stdafx.h"

#include <iostream>
#include <string>
#include <vector>

using namespace std;

class cClase1 {
public:
	cClase1()
	{
		str1 = "clase1";
	}
public:
	string str1;
	int int1;

	void Print() {
		cout  << str1 << "\n";
	}

};

class cClase2 {
public:
	cClase2() {
		str2 = "clase2";
	}
public:
	string str2;
	int int2;
	vector<cClase1> v;
public:
	void Print() {
		cout  << str2 << "\n";
	}
};

template <typename T> void insert_element(vector<T> &val) 
{
	val.push_back(T());
}

template <typename T> void print(vector<T> &val) 
{
	typename vector<T>::iterator it;
	for (it=val.begin(); it!=val.end();it++)
	{
		(*it).Print();
	}
}



//
int _tmain(int argc, _TCHAR* argv[])
{
	vector<cClase1> vector1;
	vector<cClase2> vector2;

	insert_element(vector1);
	insert_element(vector2);

	vector2[0].v.push_back(cClase1());

	print(vector2);

	return 0;
}

