// PruebaTemplatesReferencias.cpp: define el punto de entrada de la aplicación de consola.
//

#include "stdafx.h"
#include <string.h>
#include <stdio.h>

#include <iostream>
#include <string>
#include <vector>
#include <fstream>

#include "../../uv5ki-gw-cfg/include/rapidxml-1.13/rapidxml.hpp"

using namespace std;
using namespace rapidxml;

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

/** */
void TestRapidXml()
{
	cout << "Parsing my beer journal..." << endl;
	xml_document<> doc;
	xml_node<> * root_node;
	// Read the xml file into a vector
	ifstream theFile ("sample.xml");
	vector<char> buffer((istreambuf_iterator<char>(theFile)), istreambuf_iterator<char>());
	buffer.push_back('\0');
	// Parse the buffer using the xml file parsing library into doc 
	doc.parse<0>(&buffer[0]);
	// Find our root node
	root_node = doc.first_node("MyBeerJournal");
	// Iterate over the brewerys
	for (xml_node<> * brewery_node = root_node->first_node("Brewery"); brewery_node; brewery_node = brewery_node->next_sibling())
	{
	    printf("I have visited %s in %s. ", 
	    	brewery_node->first_attribute("name")->value(),
	    	brewery_node->first_attribute("location")->value());
            // Interate over the beers
	    for(xml_node<> * beer_node = brewery_node->first_node("Beer"); beer_node; beer_node = beer_node->next_sibling())
	    {
	    	printf("On %s, I tried their %s which is a %s. ", 
	    		beer_node->first_attribute("dateSampled")->value(),
	    		beer_node->first_attribute("name")->value(), 
	    		beer_node->first_attribute("description")->value());
	    	printf("I gave it the following review: %s", beer_node->value());
	    }
	    cout << endl;
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

	TestRapidXml();

	return 0;
}

