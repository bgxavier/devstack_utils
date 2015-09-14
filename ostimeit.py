import time

def timeit(info):
	def decorator(method):
		def wrapper(*args, **kw):
			ts = time.time() * 1000
			result = method(*args, **kw)
			te = time.time() * 1000

			print info + ": " + '%r %s miliseconds' % (method.__name__, te-ts)
			return result
		return wrapper
	return decorator
