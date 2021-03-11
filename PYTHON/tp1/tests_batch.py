import unittest

from tests_client import TestProtocol, TestResults as clt_TR, TestErrors as clt_TE
from tests_server import TestErrors as srv_TE, TestResults as srv_TR, TestBase, TestEdgeCases, TestProtocolFields, \
    TestRegisteredFunctions

'''assigns tests_client unit test classes to a variable'''
c1 = unittest.TestLoader().loadTestsFromTestCase(TestProtocol)
c2 = unittest.TestLoader().loadTestsFromTestCase(clt_TR)
c3 = unittest.TestLoader().loadTestsFromTestCase(clt_TE)

''' assigns tests_server unit test classes to a variable '''
s1 = unittest.TestLoader().loadTestsFromTestCase(srv_TE)
s2 = unittest.TestLoader().loadTestsFromTestCase(srv_TR)
s3 = unittest.TestLoader().loadTestsFromTestCase(TestBase)
s4 = unittest.TestLoader().loadTestsFromTestCase(TestEdgeCases)
s5 = unittest.TestLoader().loadTestsFromTestCase(TestProtocolFields)
s6 = unittest.TestLoader().loadTestsFromTestCase(TestRegisteredFunctions)

'''creates test suites for both tests_server and tests_client'''
clientTestSuite = unittest.TestSuite([c1, c2, c3])
serverTestSuite = unittest.TestSuite([s1, s2, s3, s4, s5, s6])

'''runs the suites with verbosity = 2 for a more complete output'''
unittest.TextTestRunner(verbosity=2).run(clientTestSuite)
unittest.TextTestRunner(verbosity=2).run(serverTestSuite)

